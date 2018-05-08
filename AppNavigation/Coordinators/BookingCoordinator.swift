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
            }
        default:
            print("Did not implement navigation to \(destination). Forwarding to parent")
            parent?.navigate(to: destination)
        }
    }
}
