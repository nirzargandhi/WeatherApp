//
//  AppDelegate+Configuration.swift
//  Rello
//

//MARK: - Environment Main Class
class Environment {
    class Val { private init(){} }
    class Enums { private init(){} }
}

// MARK: - Environment Types
extension Environment.Enums {
    
    enum EnvironmentType: String {

        case development = "Development"
        case production = "Production"
    }
}

//MARK: - Environment Values
extension Environment.Val {
    
    static var all: [String: Any] {
        return Bundle.main.infoDictionary?["LSEnvironment"] as? [String: Any] ?? [:]
    }
    
    private enum Keys: String {
        case environment = "Environment"
        case host = "Host"
        case appID = "AppID"
    }
    
    private static func get<T>(value key: Keys, type: T.Type) -> T? {
        return all[key.rawValue] as? T
    }
}

extension Environment.Val {
    
    static var type: Environment.Enums.EnvironmentType {
        let environment = get(value: .environment, type: String.self)!
        return Environment.Enums.EnvironmentType(rawValue: environment)!
    }
    
    static var appID: Int { return get(value: .appID, type: Int.self)! }
    static var host: String { return get(value: .host, type: String.self)! }
}

extension Environment {
    static var isDevelopment: Bool { Val.appID == 0 }
}
