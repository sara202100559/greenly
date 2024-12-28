////
////  StoreListTableViewController.swift
////  Greenly
////
////  Created by Sumaya Janahi on 27/12/2024.
////
//
//import UIKit
//import FirebaseFirestore
//
//class StoreListTableViewController: UITableViewController, UISearchBarDelegate {
//
//    // MARK: - Properties
//    var stores: [Details] = [] // Array to store store details
//    var filteredStores: [Details] = []
//    var searchBar: UISearchBar? // Search bar instance
//    let db = Firestore.firestore() // Firestore database reference
//
//    // MARK: - Lifecycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Customer Home"
//
//        setupSearchBar()
//        fetchStoresFromFirestore()
//
//        tableView.rowHeight = 80
//        tableView.separatorStyle = .singleLine
//
//        // Initialize filteredStores with all stores initially
//        filteredStores = stores
//    }
//
//    // MARK: - Firebase Firestore Fetch
//    private func fetchStoresFromFirestore() {
//        db.collection("Stores").addSnapshotListener { [weak self] snapshot, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("Error fetching stores: \(error.localizedDescription)")
//                return
//            }
//
//            guard let documents = snapshot?.documents else {
//                print("No documents found")
//                return
//            }
//
//            // Update the stores array with current Firestore data
//            self.stores = documents.compactMap { document in
//                let data = document.data()
//                guard let name = data["name"] as? String,
//                      let email = data["email"] as? String,
//                      let num = data["number"] as? String,
//                      let location = data["location"] as? String,
//                      let web = data["website"] as? String,
//                      let from = data["from"] as? String,
//                      let to = data["to"] as? String,
//                      let logoUrl = data["logoUrl"] as? String else {
//                    return nil
//                }
//
//                return Details(
//                    id: document.documentID,
//                    name: name,
//                    email: email,
//                    num: num,
//                    pass: "",
//                    image: UIImage(),
//                    location: location,
//                    web: web,
//                    from: from,
//                    to: to,
//                    logoUrl: logoUrl
//                )
//            }
//
//            // Update the filteredStores array and reload the table view
//            self.filteredStores = self.stores
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    // MARK: - Search Bar Setup
//    private func setupSearchBar() {
//        searchBar = UISearchBar()
//        searchBar?.placeholder = "Search Stores"
//        searchBar?.delegate = self
//        searchBar?.sizeToFit()
//        tableView.tableHeaderView = searchBar // Add search bar to table header
//    }
//
//    // MARK: - Search Bar Delegate
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredStores = stores // Show all stores if search text is empty
//        } else {
//            filteredStores = stores.filter {
//                $0.name.lowercased().contains(searchText.lowercased()) ||
//                $0.location.lowercased().contains(searchText.lowercased())
//            }
//        }
//        tableView.reloadData()
//    }
//
//    // MARK: - TableView DataSource
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1 // Single section for filtered stores
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredStores.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreTableViewCell
//        let store = filteredStores[indexPath.row]
//        cell.name.text = store.name
//
//        // Load the logo image asynchronously
//        if let url = URL(string: store.logoUrl) {
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        cell.photo.image = image
//                    }
//                }
//            }
//        }
//        return cell
//    }
//}

//
//  StoreListTableViewController.swift
//  Greenly
//

import UIKit
import FirebaseFirestore

class StoreListTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: - Properties
    var stores: [Details] = [] // Array to store store details
    var filteredStores: [Details] = []
    let db = Firestore.firestore() // Firestore database reference
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Stores"
        searchBar.delegate = self
        searchBar.sizeToFit()
        return searchBar
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Customer Home"

        setupSearchBar()
        fetchStoresFromFirestore()

        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
    }

    // MARK: - Firebase Firestore Fetch
    private func fetchStoresFromFirestore() {
        db.collection("Stores").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching stores: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            // Update the stores array with current Firestore data
            self.stores = documents.compactMap { document in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let email = data["email"] as? String,
                      let num = data["number"] as? String,
                      let location = data["location"] as? String,
                      let web = data["website"] as? String,
                      let from = data["from"] as? String,
                      let to = data["to"] as? String,
                      let logoUrl = data["logoUrl"] as? String else {
                    return nil
                }

                return Details(
                    id: document.documentID,
                    name: name,
                    email: email,
                    num: num,
                    pass: "",
                    image: UIImage(),
                    location: location,
                    web: web,
                    from: from,
                    to: to,
                    logoUrl: logoUrl
                )
            }

            DispatchQueue.main.async {
                self.filteredStores = self.stores
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Search Bar Setup
    private func setupSearchBar() {
        tableView.tableHeaderView = searchBar // Add search bar to table header
    }

    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredStores = stores // Show all stores if search text is empty
        } else {
            filteredStores = stores.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.location.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreTableViewCell
        let store = filteredStores[indexPath.row]
        cell.name.text = store.name

        if let url = URL(string: store.logoUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.photo.image = image
                    }
                }
            }
        }
        return cell
    }
}
