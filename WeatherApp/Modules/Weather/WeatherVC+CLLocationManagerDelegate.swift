//
//  WeatherVC+CLLocationManagerDelegate.swift
//  WeatherApp
//

//MARK: - CLLocationManagerDelegate Extension
extension WeatherVC : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            objLocationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        objLocationManager.stopUpdatingLocation()

        if let lastLocation = locations.last {
            if isAPICallFirstTime {
                wsWeatherData(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)

                isAPICallFirstTime = false
            }
        }

        if locations.first != nil {
            debugPrint("location:: \(locations[0])")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        debugPrint("Failed to find user's location: \(error.localizedDescription)")

        if arrWeatherData.count == 0 {
            lblNoData.isHidden = false
            tblWeatherList.isHidden = true
        }
    }
}
