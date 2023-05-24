//
//  Constants.swift
//

//MARK: - Colors
extension UIColor { 

    class func appBg() -> UIColor { return UIColor(named: "AppBg")! }
    class func appBlack() -> UIColor { return UIColor(named: "AppBlack")! }
    class func appGray() -> UIColor { return UIColor(named: "AppGray")! }
    class func appLightGray() -> UIColor { return UIColor(named: "AppLightGray")! }
    class func appRed() -> UIColor { return UIColor(named: "AppRed")! }
    class func appWhite() -> UIColor { return UIColor(named: "AppWhite")! }
    class func appYellow() -> UIColor { return UIColor(named: "AppYellow")! }
}

//MARK: - Global
enum GlobalConstants {
    
    static let appName    = Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

//MARK: - StoryBoard Identifier's
enum AllStoryBoard {
    
    static let Main = UIStoryboard(name: "Main", bundle: nil)
}

//MARK: - ViewController Names
enum ViewControllerName {

    static let kWeatherVC = "WeatherVC"
}

//MARK: - Cell Identifiers
enum CellIdentifiers {

    static let kCellWeather = "CellWeather"
}

//MARK: - Message's
enum AlertMessage {
    
    //In Progress Message
    static let msgComingSoon = "Coming soon"
    
    //Internet Connection Message
    static let msgNetworkConnection = "You are not connected to internet. Please connect and try again"
    
    //Camera, Images and ALbums Related Messages
    static let msgPhotoLibraryPermission = "Please enable access for photos from Privacy Settings"
    static let msgCameraPermission = "Please enable camera access from Privacy Settings"
    static let msgNoCamera = "Device has no camera"
    static let msgImageSaveIssue = "Photo is unable to save in your local storage. Please check storage or try after some time"
    static let msgSelectPhoto = "Please select photo"
    static let msgNotFoundBackCamera = "Could not find a back camera"
    static let msgNotCreateVideoDevice = "Could not create video device input"
    static let msgNotAddVideoInputSession = "Could not add video device input to the session"
    static let msgNotAdVideoOutputSession = "Could not add video data output to the session"
    
    //Unauthorized & InActive Message
    static let msgUnauthorized = "You are unauthorized. Please login again"
    static let msgInactiveLogout = "You have been automatically logged out due to inactivity"
    
    //General Error Message
    static let msgError = "Oops! That didn't work. Please try later :("
    
    //No data found Message
    static let msgNoDataFound = "No data found"
    
    //Validation Messages
    static let msgName = "Please enter name"
    static let msgValidCharacterName = "Name must contain atleast 2 characters and maximum 30 characters"
    static let msgValidName = "Please enter valid name"
    
    static let msgEmailPhoneNumber = "Please enter email address or phone number"

    static let msgEmail = "Please enter email address"
    static let msgValidEmail = "Please enter valid email address"
    
    static let msgPassword = "Please enter password"
    static let msgPasswordCharacter = "Password must contain atleast 8 characters and maximum 16 characters"
    static let msgValidPassword = "Password should contain atleast 8 characters, one uppercase letter, one letter"
    
    //Logout Message
    static let msgLogout = "Are you sure you want to log out from the application?"
}

//MARK: - Web Service URLs
enum WebServiceURL {
    
    //Dev URL
    static let mainDevURL = "https://api.openweathermap.org/data/2.5/"
    
    //Live URL
    static let mainLiveURL = "https://api.openweathermap.org/data/2.5/"

    static let weatherURL = strMainURL + "weather?"
    
    static let iconURL = "https://openweathermap.org/img/wn/"
}

//MARK: - Web Service Parameters
enum WebServiceParameter {

    static let pLat = "lat"
    static let pLon = "lon"
    static let pSearch = "q"
    static let pUnits = "units"
    static let pAppId = "appid"
}

//MARK: - User Default
enum UserDefaultsKey {

    static let kLastSearchedLocation = "last_searched_location"
}

//MARK: - Open Weather APIKey
enum OpenWeather {

    static let pAPIKey = "558e0d2d3d9e5d4a804052c771a0345b"
}

//MARK: - Constants
struct Constants {
    
    //MARK: - Device Type
    enum UIUserInterfaceIdiom : Int {
        
        case Unspecified
        case Phone
        case Pad
    }
    
    //MARK: - Screen Size
    struct ScreenSize {
        
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
}

//MARK: - DateTime Format
enum DateAndTimeFormatString {

    static let strDateFormate_yyyymmddHHmmss = "yyyy-MM-dd HH:mm:ss"
    static let strDateFormate_yyyyMMdd = "yyyy/MM/dd"
    static let strDateFormate_yyyyMMdd2 = "yyyy-MM-dd"
    static let strDateFormate_ddMMyyyy = "dd/MM/yyyy"
    static let strDateFormate_ddmmmmmyyyy = "dd MMMM yyyy"
    static let strDateFormate_yyyy = "yyyy"
    static let strDateFormate_hhmma = "hh:mm a"
}


