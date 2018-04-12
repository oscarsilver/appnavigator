//
//  UIView+Autolayout.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

extension UIView {
    func center(in view: UIView) {
        self.activate(constraints: [
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }

    func edges(to view: UIView) {
        self.activate(constraints: [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    private func activate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}
