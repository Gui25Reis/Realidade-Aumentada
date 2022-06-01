/* Gui Reis & Gabi Namie     -    Created on 01/06/22 */


import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /* MARK: - Atributos */
    
    var window: UIWindow?

    
    /* MARK: - Delegate */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainViewController()        // View Controller Inicial
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}
}

