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
        let collectionListVC = CollectionListViewController()
        collectionListVC.tabBarItem.image = UIImage(systemName: "photo.on.rectangle.angled")
        collectionListVC.tabBarItem.title = "Collections"
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([collectionListVC, mainVC], animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}
