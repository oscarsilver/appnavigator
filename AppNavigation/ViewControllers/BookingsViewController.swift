//
//  SecondTabViewController.swift
//  AppNavigation
//
//  Created by Oscar Silver on 2018-04-12.
//  Copyright © 2018 eBerry. All rights reserved.
//

import UIKit

class BookingsViewController: UITableViewController {

    let bookings: [Booking] = [Booking(hotelName: "The Thief"), Booking(hotelName: "Comfort Hotel Express")]

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

extension BookingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookingTableViewCell.identifier, for: indexPath)
        if let cell = cell as? BookingTableViewCell, let booking = booking(at: indexPath) {
            cell.configure(with: booking, navigation: navigation)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        guard let booking = booking(at: indexPath) else { return }
        navigation(self, AppStep.bookings(.cancel(booking)))
    }
}

private extension BookingsViewController {
    func setupViews() {
        title = "Bookings"
        view.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.register(BookingTableViewCell.self, forCellReuseIdentifier: BookingTableViewCell.identifier)
    }

    func setupConstriants() {}

    func booking(at indexPath: IndexPath) -> Booking? {
        guard indexPath.row < bookings.count else { return nil }
        return bookings[indexPath.row]
    }
}
