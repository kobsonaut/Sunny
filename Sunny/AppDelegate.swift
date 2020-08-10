//
//  AppDelegate.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let appContext = AppContext()

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        window = UIWindow()
        let weatherVC = appContext.weatherVC
        let navigationVC = UINavigationController(rootViewController: weatherVC)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        return true
    }
}
