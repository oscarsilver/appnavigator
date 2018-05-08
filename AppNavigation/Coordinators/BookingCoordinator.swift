//
//  BookingCoordinator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-05-04.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class BookingCoordinator: TabCoordinator {

    override class var identifier: String { return String(describing: self) }

    init(parent: Coordinating, tabIndex: Int) {
        super.init(parent: parent, tabIndex: tabIndex)
        rootViewController = UINavigationController(rootViewController: BookingsViewController(navigation: defaultNavigation))
    }

    override func navigate(to destination: Destination) {
        guard let appStep = destination as? AppStep else { return }
        switch appStep {
        case .bookings(let subDestination):
            guard let rootViewController = rootViewController as? UINavigationController else { return }
            switch subDestination {
            case .list:
                rootViewController.popToRootViewController(animated: true)
            case .details(let booking):
                let bookingDetailsViewController = BookingDetailsViewController(booking: booking)
                rootViewController.pushViewController(bookingDetailsViewController, animated: true)
            case .cancel(let booking):
                let alertController  = createAlertController(title: "Cancel Booking?", message: booking.hotelName)
                rootViewController.present(alertController, animated: true)
            }
        default:
            print("Did not implement navigation to \(destination). Forwarding to parent")
            parent?.navigate(to: destination)
        }
    }
}

private extension BookingCoordinator {
    func createAlertController(title: String?, message: String? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            alertController.dismiss(animated: true)
        }
        let dismissAction = UIAlertAction(title: "No", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(dismissAction)
        return alertController
    }
}
