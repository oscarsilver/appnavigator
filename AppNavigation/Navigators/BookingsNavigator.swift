//
//  SecondTabNavigator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class BookingsNavigator: Navigator {
    lazy var rootViewController: UIViewController? = UINavigationController(rootViewController: BookingsViewController(navigator: self))

    enum Destination {
        case list
        case details(Booking?)
    }

    func navigate(to destination: Destination) {
        guard let rootViewController = rootViewController as? UINavigationController else { return }
        switch destination {
        case .list:
            rootViewController.popToRootViewController(animated: false)
        case .details(let booking):
            rootViewController.pushViewController(BookingDetailsViewController(booking: booking), animated: true)
        }
    }
}
