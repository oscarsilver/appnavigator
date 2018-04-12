//
//  BookingDetailsViewController.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class BookingDetailsViewController: UIViewController {
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "BookingDetailsViewController"
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

private extension BookingDetailsViewController {
    func setupViews() {
        title = "Booking Details"
        view.backgroundColor = .white
        view.addSubview(label)
    }

    func setupConstraints() {
        label.center(in: view)
    }
}
