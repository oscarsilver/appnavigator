//
//  Navigator.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

protocol Navigator: Equatable {
    associatedtype Destination
    static var identifier: String { get }
    var rootViewController: UIViewController? { get }
    func navigate(to destination: Destination)
}

extension Navigator {
    static var identifier: String {
        return String(describing: type(of: self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return type(of: lhs).identifier == type(of: rhs).identifier
    }
}

struct AnyNavigator: Navigator {
    typealias Destination = Any
    private let _rootViewController: UIViewController?
    private let _navigate: (Destination) -> ()

    let tabIndex: Int?

    init<Concrete: Navigator>(_ concrete: Concrete, tabIndex: Int? = nil) {
        _navigate = { anyDestination in
            guard let destination = anyDestination as? Concrete.Destination else { fatalError("Should not happen") }
            concrete.navigate(to: destination)
        }
        _rootViewController = concrete.rootViewController
        self.tabIndex = tabIndex
    }

    func navigate(to destination: Destination) {
        _navigate(destination)
    }

    var rootViewController: UIViewController? {
        return _rootViewController
    }
}
