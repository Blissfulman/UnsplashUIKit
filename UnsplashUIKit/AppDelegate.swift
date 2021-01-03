//
//  AppDelegate.swift
//  UnsplashUIKit
//
//  Created by User on 01.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let mainVC = MainViewController(nibName: nil, bundle: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
}
