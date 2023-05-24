//
//  AppDelegate.swift
//  WeatherApp
//

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - Variable Declaration
    var window: UIWindow?

    //MARK: - AppDelegate Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard !JailbreakDetector().isJailbreakDetected else { exit(0) }

        configApp()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        state = application.applicationState
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        state = application.applicationState
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

