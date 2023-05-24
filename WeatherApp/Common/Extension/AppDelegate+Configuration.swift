//
//  AppDelegate+Configuration.swift
//  Rello
// 

//MARK: - AppDelegate Extension
extension AppDelegate {
    
    //MARK: - Config App Method
    func configApp() {

        setIQKeyboard()
        
        strMainURL = isSimulatorOrTestFlight() ? WebServiceURL.mainDevURL : WebServiceURL.mainLiveURL

        setRootController()
    }

    //MARK: - Set IQKeyboard Method
    func setIQKeyboard() {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    //MARK: - Is Simulator Or TestFlight Method
    func isSimulatorOrTestFlight() -> Bool {
        
        guard let path = Bundle.main.appStoreReceiptURL?.path else {
            return false
        }
        
        return path.contains("CoreSimulator") || path.contains("sandboxReceipt")
    }
    
    //MARK: - Set Root Controller Method
    func setRootController() {
        Utility().setRootCityListVC()
    }
}
