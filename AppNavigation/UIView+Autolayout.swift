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

    func edges(to view: UIView, insets: UIEdgeInsets = .zero) {
        self.activate(constraints: [
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
            ])
    }

    private func activate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}
