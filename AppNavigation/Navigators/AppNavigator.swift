//
//  AppNavigator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class AppNavigator: Navigator {

    private weak var window: UIWindow?
    var rootViewController: UIViewController?

    var childNavigators: [String: AnyNavigator] = [:]

    init(window: UIWindow?) {
        self.window = window
        self.rootViewController = createTabBarController()
        self.window?.rootViewController = rootViewController
    }

    enum Destination {
        case onboarding
        case moreMenu(MoreMenuNavigator.Destination)
        case bookings(BookingsNavigator.Destination)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .onboarding:
            rootViewController?.present(OnboardingViewController(navigator: self), animated: false)
        case .moreMenu(let destination):
            rootViewController?.presentedViewController?.dismiss(animated: false)
            navigateToTab(navigatorIdentifier: MoreMenuNavigator.identifier, destination)
        case .bookings(let destination):
            rootViewController?.presentedViewController?.dismiss(animated: false)
            navigateToTab(navigatorIdentifier: BookingsNavigator.identifier, destination)
        }
    }

    func start() {
        navigate(to: .onboarding)
    }
}

private extension AppNavigator {

    func navigateToTab(navigatorIdentifier: String, _ destination: Any) {
        guard let navigator = childNavigators[navigatorIdentifier],
            let tabBarController = rootViewController as? UITabBarController else { return }

        if let tabIndex = navigator.tabIndex {
            tabBarController.selectedIndex = tabIndex
        }

        navigator.navigate(to: destination)
    }

    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        let navigators = [AnyNavigator(BookingsNavigator(), tabIndex: 0), AnyNavigator(MoreMenuNavigator(), tabIndex: 1)]
        childNavigators[BookingsNavigator.identifier] = navigators[0]
        childNavigators[MoreMenuNavigator.identifier] = navigators[1]
        tabBarController.viewControllers = navigators.compactMap { $0.rootViewController }
        return tabBarController
    }
}
