//
//  Coordinator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-05-03.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

typealias NavigationCompletion = (UIViewController, Destination) -> Void

enum Destination {
    indirect case bookings(BookingDestination)
    enum BookingDestination {
        case list
        case details(Booking)
    }

    indirect case moreMenu(MoreMenuDestination)
    enum MoreMenuDestination {
        case root
        case settings
    }

    case onboarding
    case none
}

protocol Coordinator: class {
    var parent: Coordinator? { get }
    var rootViewController: UIViewController? { get }
    func navigate(to destination: Destination)
}

class AppCoordinator: Coordinator {
    var parent: Coordinator? = nil

    private weak var window: UIWindow?
    var rootViewController: UIViewController?

    var childCoordinators: [Coordinator] = []

    lazy var defaultNavigationCompletion: NavigationCompletion = { [weak self] _, nextDestination in
        self?.navigate(to: nextDestination)
    }

    init(window: UIWindow?) {
        self.window = window
        self.rootViewController = createTabBarController()
        self.window?.rootViewController = rootViewController
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .bookings:
            childCoordinators[0].navigate(to: destination)
        case .moreMenu:
            childCoordinators[1].navigate(to: destination)
        case .onboarding:
            let onboardingViewController = OnboardingViewController { [weak self] viewController, nextDestination in
                self?.navigate(to: nextDestination)
                viewController.dismiss(animated: true)
            }
            rootViewController?.present(onboardingViewController, animated: true)
        default:
            print("Navigation to \(destination) not implemented yet")
        }
    }

    func start() {
        navigate(to: .onboarding)
    }
}

// MARK: - Private Methods
private extension AppCoordinator {
    func createTabBarController() -> UITabBarController {
        let bookingCoordinator = BookingCoordinator(parent: self)
        let moreMenuCoordinator = MoreMenuCoordinator(parent: self)
        childCoordinators.append(bookingCoordinator)
        childCoordinators.append(moreMenuCoordinator)

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = childCoordinators.compactMap { $0.rootViewController }
        return tabBarController
    }
}
