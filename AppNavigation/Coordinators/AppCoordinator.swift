//
//  Coordinator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-05-03.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

protocol Presentable {
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension Presentable {
    func dismiss(animated: Bool = true) {
        self.dismiss(animated: animated, completion: nil)
    }
}

extension UIViewController: Presentable {}

protocol Destination {}

typealias Navigation = (Presentable, Destination) -> Void

enum AppStep: Destination {
    indirect case bookings(BookingDestination)
    enum BookingDestination: Destination {
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

protocol Coordinator: AnyObject {
    static var identifier: String { get }
    var rootViewController: UIViewController? { get }
    func navigate(to destination: Destination)
}

protocol ChildCoordinator: Coordinator {
    var parent: Coordinator? { get }
}

protocol TabCoordinator: ChildCoordinator {
    var tabIndex: Int { get }
}

extension Coordinator {
    func navigate(to step: AppStep) {
        self.navigate(to: step as Destination)
    }
}

extension Coordinator {
    static var identifier: String {
        return String(describing: type(of: self))
    }
}

class AppCoordinator: Coordinator {

    private weak var window: UIWindow?
    var rootViewController: UIViewController?

    var childCoordinators: [String: ChildCoordinator] = [:]

    lazy var defaultnavigation: Navigation = { [weak self] _, nextDestination in
        self?.navigate(to: nextDestination)
    }

    init(window: UIWindow?) {
        self.window = window
        self.rootViewController = createTabBarController()
        self.window?.rootViewController = rootViewController
    }

    func navigate(to destination: Destination) {
        guard let appStep = destination as? AppStep else { return }
        switch appStep {
        case .bookings:
            navigateToTab(coordinatorIdentifier: BookingCoordinator.identifier, destination)
        case .moreMenu:
            navigateToTab(coordinatorIdentifier: MoreMenuCoordinator.identifier, destination)
        case .onboarding:
            let onboardingViewController = OnboardingViewController { [weak self] presentable, nextDestination in
                self?.navigate(to: nextDestination)
                presentable.dismiss(animated: true)
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
        guard let tabCoordinator = childCoordinators[coordinatorIdentifier] as? TabCoordinator,
            let tabBarController = rootViewController as? UITabBarController else { return }
        tabBarController.selectedIndex = tabCoordinator.tabIndex
        tabCoordinator.navigate(to: destination)
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
