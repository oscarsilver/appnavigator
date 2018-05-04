//
//  BookingCoordinator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-05-04.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class BookingCoordinator: Coordinator {

    lazy var defaultnavigation: Navigation = { [weak self] _, nextDestination in
        self?.navigate(to: nextDestination)
    }

    lazy var rootViewController: UIViewController? = UINavigationController(rootViewController: BookingsViewController(navigation: defaultnavigation))
    weak var parent: Coordinator?

    init(parent: Coordinator) {
        self.parent = parent
    }

    func navigate(to destination: Destination) {
        switch destination {
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
