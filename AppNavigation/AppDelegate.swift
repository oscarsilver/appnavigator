//
//  AppDelegate.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var navigator: AppNavigator = AppNavigator(window: self.window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        navigator.start()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let destination = parse(url) else { return false }
        navigator.navigate(to: destination)
        return true
    }
}

private extension AppDelegate {
    func parse(_ url: URL) -> AppNavigator.Destination? {
        guard let host = url.host else { return nil }

        let subPath = url.pathComponents.last

        switch host {
        case "more":
            if let subPath = subPath, subPath == "settings" {
                return .moreMenu(.settings)
            } else {
                return .moreMenu(.root)
            }
        case "bookings":
            if let subPath = subPath, subPath == "details" {
                return .bookings(.details(nil))
            } else {
                return .bookings(.list)
            }
        default:
            return nil
        }
    }
}
