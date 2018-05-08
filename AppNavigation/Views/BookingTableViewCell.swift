//
//  BookingTableViewCell.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-13.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {
    static var identifier: String { return String(describing: type(of: self)) }

    private lazy var nameLabel: UILabel = UILabel(frame: .zero)

    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()

    private var views: [UIView] { return [nameLabel, button] }

    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: views)
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private var booking: Booking?
    private var navigation: Navigation?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) { requiredInit }

    func configure(with booking: Booking, navigation: @escaping Navigation) {
        self.booking = booking
        self.navigation = navigation
        nameLabel.text = booking.hotelName
    }
}

extension BookingTableViewCell {
    @objc func cancelButtonPressed(_ button: UIButton) {
        guard let booking = booking else { return }
        navigation?(nil, AppStep.bookings(.cancel(booking)))
    }
}

private extension BookingTableViewCell {
    func setupViews() {
        contentView.addSubview(stackView)
        button.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
    }

    func setupConstraints() {
        stackView.edges(to: contentView, insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        button.widthAnchor.constraint(equalToConstant: 72).isActive = true
    }
}
