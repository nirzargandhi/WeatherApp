//
//  UITextFieldExtension.swift
//

// MARK: - UITextField Character Limit
private var kAssociationKeyMaxLength: Int = 0

let nameRegex = "^(?=.{2,130}$)[A-Za-zÀ-ú][A-Za-zÀ-ú.'-]+(?: [A-Za-zÀ-ú.'-]+)* *$"
let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
let passwordRegex = "^(?=.{8,})(?=.*[a-z])(?=.*[A-Z]).*$"
let alphanumericRegex = "^(?=.*\\d)(?=.*\\D)([a-zA-Z0-9]{8,15})$"
let nationalInsuranceNumberRegex = "^[A-Z]{2}[0-9]{6}[A-Z]$"
let addressRegex = "^[a-zA-Z0-9 .,#;:'-]{1,40}$"

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
              prospectiveText.count > maxLength
        else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText.prefix(upTo: maxCharIndex))
        selectedTextRange = selection
    }
    
    public func addLeftTextPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    public func addLeftIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func validateName() -> Bool {
        let nameCheck = NSPredicate(format:"SELF MATCHES %@", nameRegex)
        return nameCheck.evaluate(with: self.text)
    }
    
    func validateEmail() -> Bool {
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailCheck.evaluate(with: self.text)
    }
    
    func validatePassword() -> Bool {
        let passwordCheck = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordCheck.evaluate(with: self.text)
    }
    
    func validateDigits() -> Bool {
        let digitsRegEx = "[0-9]*"
        let digitsCheck = NSPredicate(format:"SELF MATCHES %@", digitsRegEx)
        return digitsCheck.evaluate(with: self.text)
    }
    
    func validateAlphaNumeric() -> Bool {
        let alphaNumericCheck = NSPredicate(format:"SELF MATCHES %@", alphanumericRegex)
        return alphaNumericCheck.evaluate(with: self.text)
    }
    
    func validateAddress() -> Bool {
        let addressCheck = NSPredicate(format:"SELF MATCHES %@", addressRegex)
        return addressCheck.evaluate(with: self.text)
    }
    
    func validateNationalInsuranceNumber() -> Bool {
        
        var strText = self.text ?? ""
        
        strText = strText.replacingOccurrences(of: " ", with: "")
        
        let nationalInsuranceNumberCheck = NSPredicate(format:"SELF MATCHES %@", nationalInsuranceNumberRegex)
        return nationalInsuranceNumberCheck.evaluate(with: strText)
    }
    
    public var isEmpty: Bool {
        return trimmedText?.isEmpty == true
    }
    
    public var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func checkMinAndMaxLength(withMinLimit minLen: Int, withMaxLimit maxLen: Int) -> Bool {
        if (self.text!.count ) >= minLen && (self.text!.count ) <= maxLen {
            return true
        }
        return false
    }
    
    func checkLength(withMaxLimit maxLen: Int) -> Bool {
        if (self.text!.count ) == maxLen {
            return true
        }
        return false
    }
    
    func checkNationalInsuranceNumberLength(withMaxLimit maxLen: Int) -> Bool {
        
        var strText = self.text ?? ""
        
        strText = strText.replacingOccurrences(of: " ", with: "")
        
        if (strText.count) == maxLen {
            return true
        }
        return false
    }
    
    enum Direction {
        case Left
        case Right
    }
    
    func addImage(direction : Direction, image : UIImage, Frame : CGRect, backgroundColor : UIColor) {
        let View = UIView(frame: Frame)
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.contentMode = .center
        imageView.tintColor = .black
        View.addSubview(imageView)
        
        if Direction.Left == direction {
            self.leftViewMode = .always
            self.leftView = View
        } else {
            self.rightViewMode = .always
            self.rightView = View
        }
    }
}

extension UITextField {
    
    @IBInspectable var paddingLeftView: CGFloat {
        get {
            return self.leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightView: CGFloat {
        get {
            return self.leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

enum PasswordStrength: Int {
    case None
    case Weak
    case Fair
    case Good
    case Perfect
    
    static func checkStrength(password: String) -> PasswordStrength {
        
        let arrSpecialCharacter = ["`", "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "[", "]", "{", "}", "\\", "|", ";", ":", "'", "\"", "<", ">", ",", ".", "?", "/", "£"]
        
        let len: Int = password.count
        
        var strength: Int = 0
        
        switch len {
            
        case 0:
            return .None
            
        case 1...2:
            strength += 1
            
        case 3...4:
            strength += 2
            
        case 5...6:
            strength += 3
            
        default:
            strength += 4
        }
        
        let passwordCheck1 = NSPredicate(format:"SELF MATCHES %@", "^(?=.{8,})(?=.*[a-z])(?=.*[A-Z]).*$")
        if passwordCheck1.evaluate(with: password) {
            
            outer : for specialCharacter in arrSpecialCharacter {
                if password.contains(specialCharacter) {
                    strength += 1
                    break outer
                }
            }
            
            strength += 1
        }
        
        let passwordCheck3 = NSPredicate(format:"SELF MATCHES %@", "^[A-Za-z0-9 !\"#$%&£'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~].{8,}$")
        if passwordCheck3.evaluate(with: password) {
            strength += 1
        }
        
        switch strength {
            
        case 0:
            return .None
            
        case 1...2:
            return .Weak
            
        case 3...4:
            return .Fair
            
        case 5...6:
            return .Good
            
        default:
            return .Perfect
        }
    }
}
