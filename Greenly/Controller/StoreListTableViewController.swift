////
////  StoreListTableViewController.swift
////  Greenly
////
////  Created by BP-36-201-01 on 22/12/2024.
////
//
//import UIKit
//
//class StoreListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    // MARK: - Outlets
//    @IBOutlet weak var tableView: UITableView!
//
//    // MARK: - Properties
//    var store: Details?
//
//    // MARK: - Lifecycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = store?.name
//        
//        // Set up table view
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 200
//    }
//
//    // MARK: - TableView DataSource
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1 // Only one cell for now
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! StoreDetailCell
//        if let store = store {
//            cell.storeImageView.image = store.image
//            cell.storeNameLabel.text = store.name
//            cell.storeLocationLabel.text = "Location: \(store.location)"
//            cell.storeEmailLabel.text = "Email: \(store.email)"
//            cell.storePhoneLabel.text = "Phone: \(store.num)"
//            cell.storeWebsiteLabel.text = "Website: \(store.web)"
//        }
//        return cell
//    }
//}
