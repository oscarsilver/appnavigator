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
protocol Model {}

typealias Navigation = (Presentable?, Destination) -> Void

enum AppStep: Destination {
    indirect case bookings(BookingDestination)
    enum BookingDestination: Destination {
        case list
        case details(Booking)
        case cancel(Booking)
    }

    indirect case moreMenu(MoreMenuDestination)
    enum MoreMenuDestination {
        case root
        case settings
    }

    indirect case onboarding(OnboardingDestination)
    enum OnboardingDestination {
        case first
        case second
        case third
    }

    indirect case modal(ModalDestination)
    enum ModalDestination: Destination {
        case secondOnboarding
    }
    case none
}

protocol Coordinating: AnyObject {
    static var identifier: String { get }
    var rootViewController: UIViewController? { get }
    func navigate(to destination: Destination)
}

class AbstractCoordinator: Coordinating {
    var rootViewController: UIViewController?

    class var identifier: String { fatalError("impl me") }

    func navigate(to destination: Destination) {
        fatalError("Implement me")
    }

    var defaultNavigation: Navigation {
        return { [weak self] _, nextDestination in
            self?.navigate(to: nextDestination)
        }
    }

    var modalDismiss: Navigation {
        return { [weak self] presentable, _ in
            presentable?.dismiss(animated: true)
            self?.navigate(to: AppStep.none)
        }
    }

    init(rootViewController: UIViewController? = nil) {
        self.rootViewController = rootViewController
    }
}

protocol ChildCoordinating: Coordinating {
    var parent: Coordinating? { get }
}

class AbstractChildCoordinator: AbstractCoordinator, ChildCoordinating {
    var parent: Coordinating?
    init(parent: Coordinating, rootViewController: UIViewController? = nil) {
        self.parent = parent
        super.init(rootViewController: rootViewController)
    }
}

protocol TabCoordinating: ChildCoordinating {
    var tabIndex: Int { get }
}

class TabCoordinator: AbstractChildCoordinator, TabCoordinating {
    let tabIndex: Int
    init(parent: Coordinating, rootViewController: UIViewController? = nil, tabIndex: Int) {
        self.tabIndex = tabIndex
        super.init(parent: parent, rootViewController: rootViewController)
    }
}

extension Coordinating {
    func navigate(to step: AppStep) {
        self.navigate(to: step as Destination)
    }
}

extension AbstractCoordinator {
    var identifier: String {
        return type(of: self).identifier
    }
}

class AppCoordinator: AbstractCoordinator {

    private weak var window: UIWindow?

    override class var identifier: String { return String(describing: self) }

    var childCoordinators: [String: ChildCoordinating] = [:]

    init(window: UIWindow?) {
        super.init()
        self.window = window
        self.rootViewController = createTabBarController()
        self.window?.rootViewController = rootViewController
    }

    override func navigate(to destination: Destination) {
        guard let appStep = destination as? AppStep else { return }
        switch appStep {
        case .bookings:
            navigateToChildCoordinator(coordinatorIdentifier: BookingCoordinator.identifier, destination)
        case .moreMenu:
            navigateToChildCoordinator(coordinatorIdentifier: MoreMenuCoordinator.identifier, destination)
        case .onboarding:
            navigateToChildCoordinator(coordinatorIdentifier: OnboardingCoordinator.identifier, destination)
        case .modal(let destination):
            presentModal(destination)
        case .none:
            print("Nothing..")
        }
    }

    func start() {
        navigate(to: .bookings(.list))
    }
}

// MARK: - Private Methods
private extension AppCoordinator {
    func presentModal(_ destination: Destination) {
        guard let modalAppstep = destination as? AppStep.ModalDestination else { return }

        let modalViewController: UIViewController
        switch modalAppstep {
        case .secondOnboarding:
            modalViewController = SecondOnboardingViewController(navigation: modalDismiss)
        }

        rootViewController?.present(modalViewController, animated: true)
    }

    func navigateToChildCoordinator(coordinatorIdentifier: String, _ destination: Destination) {
        guard let childCoordinator = childCoordinators[coordinatorIdentifier] else { return }

        if let tabCoordinator = childCoordinator as? TabCoordinating, let tabBarController = rootViewController as? UITabBarController {
            tabBarController.selectedIndex = tabCoordinator.tabIndex
        } else if let childRootViewController = childCoordinator.rootViewController {
            rootViewController?.present(childRootViewController, animated: true)
        }

        childCoordinator.navigate(to: destination)
    }

    func addChildCoordinator(_ child: AbstractChildCoordinator) {
        childCoordinators[child.identifier] = child
    }

    func createChildCoordinators() {
        let coordinators = [
            BookingCoordinator(parent: self, tabIndex: 0),
            MoreMenuCoordinator(parent: self, tabIndex: 1),
            OnboardingCoordinator(parent: self)
        ]
        coordinators.forEach { addChildCoordinator($0) }
    }

    func createTabBarController() -> UITabBarController {
        createChildCoordinators()

        let tabCoordinators = [
            childCoordinators[BookingCoordinator.identifier],
            childCoordinators[MoreMenuCoordinator.identifier]
            ].compactMap { $0 as? TabCoordinating }

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = tabCoordinators.compactMap { $0.rootViewController }
        return tabBarController
    }
}
