//
//  MoreMenuCoordinator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-05-04.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class MoreMenuCoordinator: Coordinator {
    lazy var defaultnavigation: Navigation = { [weak self] _, nextDestination in
        self?.navigate(to: nextDestination)
    }

    lazy var rootViewController: UIViewController? = UINavigationController(rootViewController: MoreMenuViewController(navigation: defaultnavigation))
    weak var parent: Coordinator?
    let tabIndex: Int?

    init(parent: Coordinator, tabIndex: Int) {
        self.parent = parent
        self.tabIndex = tabIndex
    }

    func navigate(to destination: Destination) {
        guard let appStep = destination as? AppStep else { return }
        switch appStep {
        case .moreMenu(let subDestination):
            guard let rootViewController = rootViewController as? UINavigationController else { return }
            switch subDestination {
            case .root:
                rootViewController.popToRootViewController(animated: true)
            case .settings:
                rootViewController.pushViewController(SettingsViewController(), animated: true)
            }
        default:
            print("Did not implement navigation to \(destination). Forwarding to parent")
            parent?.navigate(to: destination)
        }
    }
}
