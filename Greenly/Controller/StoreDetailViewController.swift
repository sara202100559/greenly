//
//  StoreDetailViewController.swift
//  Greenly
//
//  Created by BP-36-201-01 on 22/12/2024.
//

import UIKit

class StoreDetailViewController: UITableViewController {

    // MARK: - Properties
    var store: Details?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = store?.name
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }

    // MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! StoreDetailCell
        if let store = store {
            cell.storeImageView.image = store.image
            cell.storeNameLabel.text = store.name
            cell.storeLocationLabel.text = "Location: \(store.location)"
            cell.storeEmailLabel.text = "Email: \(store.email)"
            cell.storePhoneLabel.text = "Phone: \(store.num)"
            cell.storeWebsiteLabel.text = "Website: \(store.web)"
        }
        return cell
    }
}
