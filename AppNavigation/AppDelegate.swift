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
    private lazy var coordinator: AppCoordinator = AppCoordinator(window: self.window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        coordinator.start()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let destination = parse(url) else { return false }
        coordinator.navigate(to: destination)
        return true
    }
}

private extension AppDelegate {
    func parse(_ url: URL) -> Destination? {
        guard let host = url.host else { return nil }

        let subPath = url.pathComponents.last

        var appStep: AppStep?

        switch host {
        case "more":
            if let subPath = subPath, subPath == "settings" {
                appStep = .moreMenu(.settings)
            } else {
                appStep = .moreMenu(.root)
            }
        case "bookings":
            if let subPath = subPath, subPath == "details" {
//                return .bookings(.details(nil))
                fatalError("Navigation to booking details not implemented yet")
            } else {
                appStep = .bookings(.list)
            }
        default: break
        }
        return appStep
    }
}
