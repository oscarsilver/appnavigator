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
        case alert(Booking)
    }

    func navigate(to destination: Destination) {
        guard let rootViewController = rootViewController as? UINavigationController else { return }
        switch destination {
        case .list:
            rootViewController.popToRootViewController(animated: false)
        case .details(let booking):
            rootViewController.pushViewController(BookingDetailsViewController(booking: booking), animated: true)
        case .alert(let booking):
            rootViewController.present(createAlertController(title: "Cancel Booking?", message: booking.hotelName), animated: true)
        }
    }
}

private extension BookingsNavigator {
    func createAlertController(title: String?, message: String? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(dismissAction)
        return alertController
    }
}
