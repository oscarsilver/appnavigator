//
//  SettingsViewController.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "SettingsViewController"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

private extension SettingsViewController {
    func setupViews() {
        title = "Settings"
        view.backgroundColor = .white
        view.addSubview(label)
    }

    func setupConstraints() {
        label.center(in: view)
    }
}
