//
//  CityListVC+UITableViewDelegate+UITableViewDataSource.swift
//  WeatherApp
//

//MARK: - UITableViewDelegate & UITableViewDataSource Extension
extension CityListVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return arrWeatherData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.kCellCityList, for: indexPath) as! CityListTVC

        let dictWeather = (arrWeatherData[indexPath.section].weather?.count ?? 0) > 0 ? arrWeatherData[indexPath.section].weather?[0] : nil

        cell.lblCity.text = arrWeatherData[indexPath.section].name ?? ""

        cell.imgvIcon.sd_setImage(with: URL(string: "\(WebServiceURL.iconURL)\(dictWeather?.icon ?? "")@2x.png"))

        let currentDateTime = Date(timeIntervalSinceNow: TimeInterval(arrWeatherData[indexPath.section].timezone ?? 0))
        cell.lblTime.text = Utility().datetimeFormatter(strFormat: DateAndTimeFormatString.strDateFormate_hhmma, isTimeZoneUTC: true).string(from: currentDateTime)

        cell.lblCurrentTemp.text = "\(arrWeatherData[indexPath.section].main?.temp ?? 0.0) C"

        cell.lblHighLowTemp.text = "\(arrWeatherData[indexPath.section].main?.temp_max ?? 0.0) C" + " | " + "\(arrWeatherData[indexPath.section].main?.temp_min ?? 0.0) C"

        cell.lblWeather.text = dictWeather?.main ?? ""

        cell.lblHumidity.text = "\(arrWeatherData[indexPath.section].main?.humidity ?? 0) %"

        cell.lblWindSpeed.text = "\(arrWeatherData[indexPath.section].wind?.speed ?? 0.0) meter/sec"

        let sunriseDateTime = Date(timeIntervalSince1970: TimeInterval(arrWeatherData[indexPath.section].sys?.sunrise ?? 0))
        cell.lblSunriseTime.text = Utility().datetimeFormatter(strFormat: DateAndTimeFormatString.strDateFormate_hhmma, isTimeZoneUTC: false).string(from: sunriseDateTime)

        let sunsetDateTime = Date(timeIntervalSince1970: TimeInterval(arrWeatherData[indexPath.section].sys?.sunset ?? 0))
        cell.lblSunsetTime.text = Utility().datetimeFormatter(strFormat: DateAndTimeFormatString.strDateFormate_hhmma, isTimeZoneUTC: false).string(from: sunsetDateTime)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
