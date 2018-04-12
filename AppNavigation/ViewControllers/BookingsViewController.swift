//
//  SecondTabViewController.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController {

    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "BookingsViewController"
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Details", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()

    private var views: [UIView] { return [self.label, self.button] }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private weak var navigator: BookingsNavigator?

    init(navigator: BookingsNavigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        requiredInit
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstriants()
    }
}

extension BookingsViewController {
    @objc func detailsButtonPressed(_ button: UIButton) {
        navigator?.navigate(to: .details)
    }
}

private extension BookingsViewController {
    func setupViews() {
        title = "Bookings"
        view.backgroundColor = .white
        view.addSubview(stackView)
        button.addTarget(self, action: #selector(detailsButtonPressed(_:)), for: .touchUpInside)
    }

    func setupConstriants() {
        stackView.center(in: view)
    }
}

