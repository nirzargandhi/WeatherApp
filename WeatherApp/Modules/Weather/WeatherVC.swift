//
//  WeatherVC.swift
//  WeatherApp
//

class WeatherVC: UIViewController {

    //MARK: - UIButton Outlet
    @IBOutlet weak var btnSearch: UIButton!

    //MARK: - UITextField Outlet
    @IBOutlet weak var txtSearch: UITextField!

    //MARK: - NSLayoutConstraint Outlets
    @IBOutlet weak var nslcTxtSearchTop: NSLayoutConstraint!
    @IBOutlet weak var nslcTxtSearchBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcTxtSearchHeight: NSLayoutConstraint!

    //MARK: - UITableView Outlet
    @IBOutlet weak var tblWeatherList: UITableView!

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
            tblWeatherList.sectionHeaderTopPadding = 0.0
            tblWeatherList.tableHeaderView = UIView()
        }

        tblWeatherList.rowHeight = UITableView.automaticDimension
        tblWeatherList.estimatedRowHeight = UITableView.automaticDimension
        tblWeatherList.tableFooterView = UIView()

        if let strLastSearchedLocation = UserDefaults.standard.string(forKey: UserDefaultsKey.kLastSearchedLocation) {

            txtSearch.text = strLastSearchedLocation

            btnSearch.isSelected = true

            updateUI()

            wsSearchWeatherData(isLoader: false)
        }
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
                self.tblWeatherList.isHidden = true
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

        hideIQKeyboard()

        clearTextField()

        btnSearch.isSelected = !btnSearch.isSelected

        updateUI()
    }

    //MARK: - Update UI Method
    private func updateUI() {

        txtSearch.isHidden = !btnSearch.isSelected

        nslcTxtSearchTop.constant = btnSearch.isSelected ? 16 : 0
        nslcTxtSearchBottom.constant = btnSearch.isSelected ? 16 : 0
        nslcTxtSearchHeight.constant = btnSearch.isSelected ? 45 : 0
    }

    //MARK: - Clear TextField Method
    private func clearTextField() {
        txtSearch.text = ""
    }

    //MARK: - Set Data Method
    private func setData() {

        arrWeatherData = arrWeatherData.sorted(by: { (a, b) -> Bool in
            return (a.currentLocation ?? 0) > (b.currentLocation ?? 0)
        })

        if arrWeatherData.count > 0 {
            tblWeatherList.reloadData()

            tblWeatherList.isHidden = false
            lblNoData.isHidden = true
        } else {
            lblNoData.isHidden = false
            tblWeatherList.isHidden = true
        }
    }

    //MARK: - Webservice Call Methods
    func wsWeatherData(latitude : Double, longitude : Double) {

        guard case ConnectionCheck.isConnectedToNetwork() = true else {
            Utility().dynamicToastMessage(strMessage: AlertMessage.msgNetworkConnection)
            return
        }

        let strURL = "\(WebServiceURL.weatherURL)\(WebServiceParameter.pLat)=\(latitude)&\(WebServiceParameter.pLon)=\(longitude)&\(WebServiceParameter.pUnits)=metric&\(WebServiceParameter.pAppId)=\(OpenWeather.pAPIKey)"

        ApiCall().get(apiUrl: strURL, model: WeatherModel.self) { [weak self] (success, responseData) in guard let self else { return }

            if success, var responseData = responseData as? WeatherModel, responseData.cod == 200 {

                responseData.currentLocation = 1

                arrWeatherData.append(responseData)

                setData()
            } else {
                mainThread {
                    self.view.makeToast(responseData != nil ? Utility().wsFailResponseMessage(responseData: responseData!) : AlertMessage.msgError)

                    if self.arrWeatherData.count == 0 {
                        self.lblNoData.isHidden = false
                        self.tblWeatherList.isHidden = true
                    }
                }
            }
        }
    }

    func wsSearchWeatherData(isLoader : Bool = true) {

        guard case ConnectionCheck.isConnectedToNetwork() = true else {
            Utility().dynamicToastMessage(strMessage: AlertMessage.msgNetworkConnection)
            return
        }

        let strURL = "\(WebServiceURL.weatherURL)\(WebServiceParameter.pSearch)=\(txtSearch.text ?? "")&\(WebServiceParameter.pUnits)=metric&\(WebServiceParameter.pAppId)=\(OpenWeather.pAPIKey)"

        ApiCall().get(apiUrl: strURL, model: WeatherModel.self, isLoader: isLoader) { [weak self] (success, responseData) in guard let self else { return }

            if success, var responseData = responseData as? WeatherModel, responseData.cod == 200 {

                responseData.currentLocation = 0

                arrWeatherData.append(responseData)

                UserDefaults.standard.set(txtSearch.text ?? "", forKey: UserDefaultsKey.kLastSearchedLocation)

                setData()

                clearTextField()
            } else {
                mainThread {
                    self.view.makeToast(responseData != nil ? Utility().wsFailResponseMessage(responseData: responseData!) : AlertMessage.msgError)

                    self.clearTextField()

                    if self.arrWeatherData.count == 0 {
                        self.lblNoData.isHidden = false
                        self.tblWeatherList.isHidden = true
                    }
                }
            }
        }
    }
}
