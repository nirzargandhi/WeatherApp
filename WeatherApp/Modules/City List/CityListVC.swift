//
//  CityListVC.swift
//  WeatherApp
//

class CityListVC: UIViewController {

    //MARK: - UITableView Outlet
    @IBOutlet weak var tblCityList: UITableView!

    //MARK: - UILabel Outlet
    @IBOutlet weak var lblNoData: UILabel!

    //MARK: - Variable Declaration
    var objLocationManager = CLLocationManager()
    var isAPICallFirstTime = true
    var arrWeatherData = [WeatherModel]()

    //MARK: - ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    //MARK: - Initialization Method
    private func initialization() {

        hideNavigationBar(isTabbar: false)

        checkLocationPermision()

        if #available(iOS 15.0, *) {
            tblCityList.sectionHeaderTopPadding = 0.0
            tblCityList.tableHeaderView = UIView()
        }

        tblCityList.rowHeight = UITableView.automaticDimension
        tblCityList.estimatedRowHeight = UITableView.automaticDimension
        tblCityList.tableFooterView = UIView()
    }

    //MARK: - Check Location Permision Method
    private func checkLocationPermision() {

        if CLLocationManager.locationServicesEnabled() {

            switch CLLocationManager.authorizationStatus() {

            case .notDetermined:
                getUserLocation()

            case .authorizedAlways, .authorizedWhenInUse:
                objLocationManager.delegate = self
                objLocationManager.startUpdatingLocation()

            case .denied, .restricted:
                showLocationPermissionAlert()

            @unknown default:
                break
            }
        } else {
            getUserLocation()
        }
    }

    //MARK: - Get User Location Method
    private func getUserLocation() {

        objLocationManager.distanceFilter = 10

        objLocationManager.delegate = self
        objLocationManager.requestAlwaysAuthorization()

        objLocationManager.startMonitoringSignificantLocationChanges()
        objLocationManager.startUpdatingLocation()

        objLocationManager.desiredAccuracy = kCLLocationAccuracyBest

        objLocationManager.pausesLocationUpdatesAutomatically = false
    }

    //MARK: - Show Location Permission Alert Method
    private func showLocationPermissionAlert() {

        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)

        let openSettingAction = UIAlertAction(title: "Open Settings", style: .default, handler: {(AlertAction) in

            NotificationCenter.default.addObserver(self, selector: #selector(self.openAndCloseActivity), name: UIApplication.willResignActiveNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(self.openAndCloseActivity), name: UIApplication.didBecomeActiveNotification, object: nil)

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(AlertAction) in
            if self.arrWeatherData.count == 0 {
                self.lblNoData.isHidden = false
                self.tblCityList.isHidden = true
            }
        })

        alertController.addAction(cancelAction)
        alertController.addAction(openSettingAction)

        self.present(alertController, animated: true, completion: nil)
    }

    //MARK: - Open And Close Activity Method
    @objc func openAndCloseActivity(_ notification: Notification)  {

        if notification.name == UIApplication.didBecomeActiveNotification {

            checkLocationPermision()

            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)

            NotificationCenter.default.removeObserver(self, name:  UIApplication.didBecomeActiveNotification, object: nil)

            NotificationCenter.default.removeObserver(self)
        } else if notification.name == UIApplication.willResignActiveNotification {

        }
    }

    //MARK: - UIButton Action Method
    @IBAction func btnSearchAction(_ sender: Any) {

    }

    //MARK: - Webservice Call Method
    func wsWeatherData(latitude : Double, longitude : Double) {

        guard case ConnectionCheck.isConnectedToNetwork() = true else {
            Utility().dynamicToastMessage(strMessage: AlertMessage.msgNetworkConnection)
            return
        }

        let strURL = "\(WebServiceURL.weatherURL)\(WebServiceParameter.pLat)=\(latitude)&\(WebServiceParameter.pLon)=\(longitude)&\(WebServiceParameter.pUnits)=metric&\(WebServiceParameter.pAppId)=\(OpenWeather.pAPIKey)"

        ApiCall().get(apiUrl: strURL, model: WeatherModel.self) { [weak self] (success, responseData) in guard let self else { return }

            if success, let responseData = responseData as? WeatherModel, responseData.cod == 200 {
                arrWeatherData.append(responseData)

                if arrWeatherData.count > 0 {
                    tblCityList.reloadData()

                    tblCityList.isHidden = false
                    lblNoData.isHidden = true
                } else {
                    lblNoData.isHidden = false
                    tblCityList.isHidden = true
                }
            } else {
                mainThread {
                    Utility().dynamicToastMessage(strMessage: AlertMessage.msgError)

                    if self.arrWeatherData.count == 0 {
                        self.lblNoData.isHidden = false
                        self.tblCityList.isHidden = true
                    }
                }
            }
        }
    }
}
