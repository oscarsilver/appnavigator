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

    func configure(with booking: Booking) {
        textLabel?.text = booking.hotelName
    }
}
