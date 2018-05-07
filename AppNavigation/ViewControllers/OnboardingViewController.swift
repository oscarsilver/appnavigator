//
//  OnboardingViewController.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "OnboardingViewController"
        label.textAlignment = .center
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Skip", for: .normal)
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

    private let navigation: Navigation

    init(navigation: @escaping Navigation) {
        self.navigation = navigation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { requiredInit }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

extension OnboardingViewController {
    @objc func skipButtonPressed(_ button: UIButton) {
        navigation(self, AppStep.bookings(.list))
    }
}

private extension OnboardingViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        button.addTarget(self, action: #selector(skipButtonPressed(_:)), for: .touchUpInside)
    }

    func setupConstraints() {
        stackView.center(in: view)
    }
}
