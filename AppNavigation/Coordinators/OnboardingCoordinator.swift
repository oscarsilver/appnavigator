//
//  OnboardingCoordinator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-05-08.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class OnboardingCoordinator: AbstractChildCoordinator {
    override class var identifier: String { return String(describing: self) }

    var onboardingNavigation: Navigation {
        return { [weak self] presentable, nextDestination in
            presentable.dismiss(animated: true)
            self?.navigate(to: nextDestination)
        }
    }

    init(parent: Coordinating) {
        super.init(parent: parent)
        rootViewController = UINavigationController(rootViewController: FirstOnboardingViewController(navigation: defaultnavigation))
    }

    override func navigate(to destination: Destination) {
        guard let appStep = destination as? AppStep else { return }
        switch appStep {
        case .onboarding(let subDestination):
            guard let rootViewController = rootViewController as? UINavigationController else { return }
            switch subDestination {
            case .first:
                rootViewController.popToRootViewController(animated: true)
            case .second:
                let secondOnboardingViewController = SecondOnboardingViewController(navigation: defaultnavigation)
                rootViewController.pushViewController(secondOnboardingViewController, animated: true)
            case .third:
                let thirdOnboardingViewController = ThirdOnboardingViewController(navigation: onboardingNavigation)
                rootViewController.pushViewController(thirdOnboardingViewController, animated: true)
            }
        default:
            print("Did not implement navigation to \(destination). Forwarding to parent")
            parent?.navigate(to: destination)
        }
    }
}
