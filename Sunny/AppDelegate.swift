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
        customizeNavigationBar()
        return true
    }

    private func customizeNavigationBar() {
        // Navigation bar
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .clientWhite
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clientWhite]
        navigationBarAppearace.barTintColor = .clientMain
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.barStyle = .black
        navigationBarAppearace.setBackgroundImage(UIImage(), for:.default)
        navigationBarAppearace.shadowImage = UIImage()
    }
}
