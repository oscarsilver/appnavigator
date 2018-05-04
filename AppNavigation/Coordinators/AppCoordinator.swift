//
//  Coordinator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-05-03.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

typealias Navigation = (UIViewController, Destination) -> Void

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
    var tabIndex: Int? { get }
    static var identifier: String { get }
    var rootViewController: UIViewController? { get }
    func navigate(to destination: Destination)
}

extension Coordinator {
    static var identifier: String {
        return String(describing: type(of: self))
    }
}

class AppCoordinator: Coordinator {
    var tabIndex: Int? = nil
    var parent: Coordinator? = nil

    private weak var window: UIWindow?
    var rootViewController: UIViewController?

    var childCoordinators: [String: Coordinator] = [:]

    lazy var defaultnavigation: Navigation = { [weak self] _, nextDestination in
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
            navigateToTab(coordinatorIdentifier: BookingCoordinator.identifier, destination)
        case .moreMenu:
            navigateToTab(coordinatorIdentifier: MoreMenuCoordinator.identifier, destination)
        case .onboarding:
            let onboardingViewController = OnboardingViewController { [weak self] viewController, nextDestination in
                self?.navigate(to: nextDestination)
                viewController.dismiss(animated: true)
            }
            rootViewController?.present(onboardingViewController, animated: false)
        default:
            print("Navigation to \(destination) not implemented yet")
        }
    }

    func start() {
        navigate(to: .bookings(.list))
    }
}

// MARK: - Private Methods
private extension AppCoordinator {
    func navigateToTab(coordinatorIdentifier: String, _ destination: Destination) {
        guard let coordinator = childCoordinators[coordinatorIdentifier],
            let tabBarController = rootViewController as? UITabBarController else { return }

        if let tabIndex = coordinator.tabIndex {
            tabBarController.selectedIndex = tabIndex
        }

        coordinator.navigate(to: destination)
    }

    func createTabBarController() -> UITabBarController {
        let bookingCoordinator = BookingCoordinator(parent: self, tabIndex: 0)
        let moreMenuCoordinator = MoreMenuCoordinator(parent: self, tabIndex: 1)
        childCoordinators[BookingCoordinator.identifier] = bookingCoordinator
        childCoordinators[MoreMenuCoordinator.identifier] = moreMenuCoordinator

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = childCoordinators.values.compactMap { $0.rootViewController }
        return tabBarController
    }
}
