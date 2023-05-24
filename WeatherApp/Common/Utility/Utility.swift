//
//  Utility.swift
//

//MARK: - Variable Declaration
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

let appDelegate = UIApplication.shared.delegate as? AppDelegate
var state : UIApplication.State!

let constValueField = "application/json"
let constStatementsPDFValueField = "application/pdf"
let constHeaderField = "Content-Type"

let multiPartFieldName = "fieldName"
let multiPartPathURLs = "pathURL"

var hud : MBProgressHUD = MBProgressHUD()

var strMainURL = ""

struct Utility {
    
    //MARK: - Show/Hide Loader Method
    func showLoader() {
        DispatchQueue.main.async {
            hud = MBProgressHUD.showAdded(to: UIApplication.shared.windows.first(where: { $0.isKeyWindow })!, animated: true)
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(hud)
            hud.mode = .indeterminate
            hud.bezelView.color = .clear
            hud.bezelView.style = .solidColor
            hud.contentColor = .appBlack()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            hud.removeFromSuperview()
        }
    }
    
    //MARK: - Dynamic Toast Message
    func dynamicToastMessage(strImage : String = "ic_info", strMessage : String) {
        
        guard let window = GlobalConstants.appDelegate.window else {
            return
        }
        
        guard strMessage != "" else {
            return
        }
        
        mainThread {
            let imgvIcon = UIImageView()
            imgvIcon.contentMode = .scaleAspectFit
            imgvIcon.image = UIImage(named: strImage)
            imgvIcon.translatesAutoresizingMaskIntoConstraints = false
            imgvIcon.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
            imgvIcon.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
            
            let lblMessage = UILabel()
            lblMessage.backgroundColor = .clear
            lblMessage.numberOfLines = 0
            lblMessage.lineBreakMode = .byWordWrapping
            lblMessage.font = UIFont.init(name: "Inter-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
            lblMessage.textAlignment = .natural
            lblMessage.textColor = .appBlack()
            lblMessage.text = strMessage
            lblMessage.translatesAutoresizingMaskIntoConstraints = false
            
            let vMessage = UIView()
            vMessage.frame = CGRect.zero
            vMessage.layer.cornerRadius = 5
            vMessage.clipsToBounds = true
            vMessage.backgroundColor = .appYellow()
            
            let labelSizeWithFixedWith = CGSize(width: ScreenWidth - 72.0, height: CGFloat.greatestFiniteMagnitude)
            let exactLabelsize = lblMessage.sizeThatFits(labelSizeWithFixedWith)
            lblMessage.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: exactLabelsize)
            
            let sizeLblMessage : CGSize = lblMessage.intrinsicContentSize
            vMessage.frame = CGRect(x: 8.0, y: window.safeAreaInsets.top + 24.0, width: ScreenWidth - 16.0, height: lblMessage.frame.height + sizeLblMessage.height + 8.0)
            
            vMessage.addSubview(imgvIcon)
            vMessage.addSubview(lblMessage)
            
            NSLayoutConstraint.activate([
                imgvIcon.topAnchor.constraint(equalTo: vMessage.topAnchor, constant: 14),
                imgvIcon.leadingAnchor.constraint(equalTo: vMessage.leadingAnchor, constant: 16),
                
                lblMessage.topAnchor.constraint(equalTo: vMessage.topAnchor, constant: 12),
                lblMessage.leadingAnchor.constraint(equalTo: vMessage.leadingAnchor, constant: 40),
                lblMessage.trailingAnchor.constraint(equalTo: vMessage.trailingAnchor, constant: -16),
                lblMessage.bottomAnchor.constraint(equalTo: vMessage.bottomAnchor, constant: -12),
            ])
            
            window.addSubview(vMessage)
            
            UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseIn, animations: {
                vMessage.alpha = 1
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    vMessage.alpha = 0
                }, completion: { finished in
                    vMessage.removeFromSuperview()
                })
            })
        }
    }

    //MARK: - WSFail Response Method
    func wsFailResponseMessage(responseData : AnyObject) -> String {
        
        var strResponseData = String()
        
        if let tempResponseData = responseData as? String {
            strResponseData = tempResponseData
        }
        
        if(isObjectNotNil(object: strResponseData as AnyObject)) && strResponseData != "" {
            return strResponseData == AlertMessage.msgUnauthorized ? "" : strResponseData
        } else {
            return AlertMessage.msgError
        }
    }
    
    //MARK: - Check Null or Nil Object
    func isObjectNotNil(object:AnyObject!) -> Bool {

        if let _:AnyObject = object {
            return true
        }
        
        return false
    }

    //MARK: - Set Root CityListVC Method
    func setRootCityListVC() {
        let objCityListVC = AllStoryBoard.Main.instantiateViewController(withIdentifier: ViewControllerName.kCityListVC) as? CityListVC
        let navigationViewController = UINavigationController(rootViewController: objCityListVC!)
        GlobalConstants.appDelegate.window!.rootViewController = navigationViewController
        GlobalConstants.appDelegate.window?.makeKeyAndVisible()
    }
    
    //MARK: -  Date Formatter Method
    func datetimeFormatter(strFormat : String, isTimeZoneUTC : Bool) -> DateFormatter {
        var dateFormatter: DateFormatter?
        if dateFormatter == nil {
            dateFormatter = DateFormatter()
            dateFormatter?.timeZone = isTimeZoneUTC ? TimeZone(abbreviation: "UTC") : TimeZone.current
            dateFormatter?.dateFormat = strFormat
        }
        return dateFormatter!
    }
}

@IBDesignable
open class ShadowView1: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

func mainThread(_ completion: @escaping () -> ()) {
    DispatchQueue.main.async {
        completion()
    }
}

func backgroundThread(_ qos: DispatchQoS.QoSClass = .background , completion: @escaping () -> ()) {
    DispatchQueue.global(qos:qos).async {
        completion()
    }
}

//MARK: - Platform
struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

//MARK: - Trim String
func trimString(string : NSString) -> NSString {
    return string.trimmingCharacters(in: NSCharacterSet.whitespaces) as NSString
}

//MARK: - UserDefault Methods
func setUserDefault<T>(_ object : T  , key : String) {
    let defaults = UserDefaults.standard
    defaults.set(object, forKey: key)
    UserDefaults.standard.synchronize()
}

func getUserDefault(_ key: String) -> AnyObject? {
    let defaults = UserDefaults.standard
    
    if let name = defaults.value(forKey: key){
        return name as AnyObject?
    }
    return nil
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

//MARK: - UserDefault & KeyChain Data Clear Method
func userDefaultKeyChainDataClear(isTermsConditionsSelected : Bool) {

}

//MARK: - Clear Global Variables Method
func clearGlobalVariables() {

}

//MARK: - Hide IQKeyboard Method
func hideIQKeyboard() {
    IQKeyboardManager.shared.resignFirstResponder()
}

//MARK: - Notification Enable/Disable Check Method
func isNotificationEnabled(completion:@escaping (_ enabled:Bool)->()) {
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
            let status =  (settings.authorizationStatus == .authorized)
            completion(status)
        })
    } else {
        if let status = UIApplication.shared.currentUserNotificationSettings?.types{
            let status = status.rawValue != UIUserNotificationType(rawValue: 0).rawValue
            completion(status)
        } else {
            completion(false)
        }
    }
}

//MARK: - Debug Print Method
func debugPrint(_ text: String) {

    if Environment.isDevelopment {
        print(text)
    }
}
