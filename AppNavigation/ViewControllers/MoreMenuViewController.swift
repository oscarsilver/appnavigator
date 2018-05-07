//
//  FirstTabViewController.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class MoreMenuViewController: UIViewController {

    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "MoreMenuViewController"
        return label
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()

    private lazy var onboardingButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Onboarding", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()

    private var views: [UIView] { return [label, settingsButton, onboardingButton] }

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

    required init?(coder aDecoder: NSCoder) {
        requiredInit
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstriants()
    }
}

extension MoreMenuViewController {
    @objc func settingsButtonPressed(_ button: UIButton) {
        navigation(self, AppStep.moreMenu(.settings))
    }

    @objc func onboardingButtonPressed(_ button: UIButton) {
        navigation(self, AppStep.onboarding)
    }
}

private extension MoreMenuViewController {
    func setupViews() {
        title = "More"
        view.backgroundColor = .white
        view.addSubview(stackView)
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed(_:)), for: .touchUpInside)
        onboardingButton.addTarget(self, action: #selector(onboardingButtonPressed(_:)), for: .touchUpInside)
    }

    func setupConstriants() {
        stackView.center(in: view)
    }
}
