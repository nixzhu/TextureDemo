//
//  AppDelegate.swift
//  Semigroup
//
//  Created by nixzhu on 2017/8/10.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        let tabBarController = UITabBarController()
        let nc1 = UINavigationController(rootViewController: TableNodeViewController())
        nc1.tabBarItem = UITabBarItem(title: "Table", image: nil, selectedImage: nil)
        let nc2 = UINavigationController(rootViewController: CollectionNodeViewController())
        nc2.tabBarItem = UITabBarItem(title: "Collection", image: nil, selectedImage: nil)
        tabBarController.setViewControllers([nc1, nc2], animated: false)
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}
