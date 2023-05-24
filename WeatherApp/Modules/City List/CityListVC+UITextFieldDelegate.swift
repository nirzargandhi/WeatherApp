//
//  CityListVC+UITextFieldDelegate.swift
//  WeatherApp
//

//MARK: - UITextField Delegate Extension
extension CityListVC : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField.returnKeyType == UIReturnKeyType.next {
            textField.superview?.superview?.superview?.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        } else if textField.returnKeyType == UIReturnKeyType.done {
            textField.resignFirstResponder()
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        UserDefaults.standard.set(textField.text ?? "", forKey: UserDefaultsKey.kLastSearchedLocation)

        wsSearchWeatherData()
    }
}
