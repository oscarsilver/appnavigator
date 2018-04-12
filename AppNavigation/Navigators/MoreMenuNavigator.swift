//
//  FirstTabNavigator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class MoreMenuNavigator: Navigator {
    lazy var rootViewController: UIViewController? = UINavigationController(rootViewController: MoreMenuViewController(navigator: self))

    enum Destination {
        case root
        case settings
    }

    func navigate(to destination: Destination) {
        guard let rootViewController = rootViewController as? UINavigationController else { return }
        switch destination {
        case .root:
            rootViewController.popToRootViewController(animated: false)
        case .settings:
            rootViewController.pushViewController(SettingsViewController(), animated: true)
        }
    }
}
