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
        let vc = TableNodeViewController()
        //let vc = CollectionNodeViewController()
        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}
