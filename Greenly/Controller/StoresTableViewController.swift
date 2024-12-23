////
////  StoresTableViewController.swift
////  Greenly
////
////  Created by BP-36-201-18 on 01/12/2024.
////
//
//import UIKit
//import FirebaseFirestore
//
//extension UITableViewController {
//    // MARK: - Navigation Methods
//    private func navigateToMainStoryboard() {
//        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let sceneDelegate = scene.delegate as? SceneDelegate else {
//            print("Failed to get SceneDelegate")
//            return
//        }
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let loginViewController = storyboard.instantiateInitialViewController() {
//            sceneDelegate.window?.rootViewController = loginViewController
//            sceneDelegate.window?.makeKeyAndVisible()
//        }
//    }
//
//    func logout() {
//        let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "No", style: .cancel))
//        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
//            self.navigateToMainStoryboard()
//        })
//        present(alert, animated: true)
//    }
//}
//
//class StoresTableViewController: UITableViewController, UISearchResultsUpdating, AddTableViewControllerDelegate {
//
//    var selectedIndex: IndexPath?
//
//    // MARK: - Properties
//    var stores: [Details] = [] // Array to store store details
//    var filteredStores: [Details] = []
//    var searchController: UISearchController?
//
//    // MARK: - Logout Action
//    @IBAction func Exit(_ sender: Any) {
//        logout()
//    }
//
//    // MARK: - Lifecycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Stores"
//        setupSearchController()
//        //setupLongPressGesture()
//
//        // Load stores from Firestore
//        fetchStoresFromFirestore()
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 80
//        tableView.separatorStyle = .none
//
//        //Fetch data from Firestore in real-time
//        fetchStoresFromFirestore()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tableView.reloadData()
//    }
//
//    // MARK: - Firebase Firestore Fetch
//    private func fetchStoresFromFirestore() {
//        let db = Firestore.firestore()
//        db.collection("Stores").addSnapshotListener { [weak self] (snapshot, error) in
//            guard let self = self else { return }
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
//            // Create a dictionary to ensure uniqueness
//            var storeDict: [String: Details] = [:]
//
//            // Parse documents into `Details` objects
//            for document in documents {
//                let data = document.data()
//                guard let name = data["name"] as? String,
//                      let email = data["email"] as? String,
//                      let num = data["number"] as? String,
//                      let pass = data["password"] as? String,
//                      let location = data["location"] as? String,
//                      let web = data["website"] as? String,
//                      let from = data["from"] as? String,
//                      let to = data["to"] as? String else {
//                    continue
//                }
//
//                // Use placeholder for image
//                let image = self.placeholderImage()
//
//                // Add to dictionary using the document ID as the key
//                storeDict[document.documentID] = Details(
//                    name: name, email: email, num: num, pass: pass, image: image, location: location, web: web, from: from, to: to
//                )
//            }
//
//            // Update the stores array with unique values
//            self.stores = Array(storeDict.values)
//
//            print("Stores updated from Firestore")
//            self.tableView.reloadData()
//        }
//    }
//
//
//
//    // MARK: - Placeholder Image
//    private func placeholderImage() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
//        return renderer.image { context in
//            UIColor.white.setFill()
//            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 20),
//                .foregroundColor: UIColor.darkGray
//            ]
//            let text = "Image"
//            let textSize = text.size(withAttributes: attributes)
//            text.draw(at: CGPoint(x: (100 - textSize.width) / 2, y: (100 - textSize.height) / 2), withAttributes: attributes)
//        }
//    }
//
//    // MARK: - Search Controller Setup
//    func setupSearchController() {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController?.searchResultsUpdater = self
//        searchController?.obscuresBackgroundDuringPresentation = false
//        searchController?.searchBar.placeholder = "Search Stores"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//    }
//
//    // MARK: - Search Results Updating
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let query = searchController.searchBar.text?.lowercased(), !query.isEmpty else {
//            filteredStores = stores
//            tableView.reloadData()
//            return
//        }
//        filteredStores = stores.filter { store in
//            store.name.lowercased().contains(query) || store.location.lowercased().contains(query)
//        }
//        tableView.reloadData()
//    }
//
//    // MARK: - TableView DataSource
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return (searchController?.isActive ?? false) ? 1 : stores.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (searchController?.isActive ?? false) ? filteredStores.count : 1
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if searchController?.isActive ?? false { return nil }
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
//        return headerView
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreTableViewCell
//        let store: Details
//        if searchController?.isActive ?? false {
//            store = filteredStores[indexPath.row]
//        } else {
//            store = stores[indexPath.section]
//        }
//        cell.name.text = store.name
//        cell.photo.image = store.image
//        return cell
//    }
//
//    // MARK: - AddTableViewControllerDelegate
//    func didSaveStore(_ store: Details, editingIndex: IndexPath?) {
//        if let editingIndex = editingIndex {
//            stores[editingIndex.section] = store
//        } else {
//            stores.append(store)
//        }
//        //saveStores()
//        tableView.reloadData()
//    }
//
//    @IBSegueAction func addEditStoreSegue(_ coder: NSCoder, sender: Any?) -> AddTableViewController? {
//        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
//            let storeToEdit = searchController?.isActive ?? false ? filteredStores[indexPath.row] : stores[indexPath.section]
//            let viewController = AddTableViewController(coder: coder, store: storeToEdit)
//            viewController?.editingIndex = indexPath
//            viewController?.delegate = self
//            return viewController
//        } else {
//            let viewController = AddTableViewController(coder: coder, store: nil)
//            viewController?.delegate = self
//            return viewController
//        }
//    }
//
//    private func fetchStoresFromFirestore() {
//        let db = Firestore.firestore()
//
//        // Real-time listener for changes in the "Stores" collection
//        db.collection("Stores").addSnapshotListener { [weak self] (snapshot, error) in
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
//            // Parse documents into Details objects
//            self.stores = documents.compactMap { document -> Details? in
//                let data = document.data()
//                guard let name = data["name"] as? String,
//                      let email = data["email"] as? String,
//                      let num = data["number"] as? String,
//                      let pass = data["password"] as? String,
//                      let location = data["location"] as? String,
//                      let web = data["website"] as? String,
//                      let from = data["from"] as? String,
//                      let to = data["to"] as? String,
//                      let logoUrl = data["logoUrl"] as? String else {
//                    return nil
//                }
//
//                // Fetch and return the store data
//                return Details(
//                    name: name,
//                    email: email,
//                    num: num,
//                    pass: pass,
//                    image: UIImage(), // Placeholder; use URL to fetch image if needed
//                    location: location,
//                    web: web,
//                    from: from,
//                    to: to,
//                    logoUrl: logoUrl // Optional if you added this property
//                )
//            }
//
//            // Reload the table view with updated data
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//}


//
//  StoresTableViewController.swift
//  Greenly
//
//  Created by BP-36-201-18 on 01/12/2024.
//

import UIKit
import FirebaseFirestore

extension UITableViewController {
    // MARK: - Navigation Methods
    private func navigateToMainStoryboard() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else {
            print("Failed to get SceneDelegate")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateInitialViewController() {
            sceneDelegate.window?.rootViewController = loginViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func logout() {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.navigateToMainStoryboard()
        })
        present(alert, animated: true)
    }
}

class StoresTableViewController: UITableViewController, UISearchResultsUpdating, AddTableViewControllerDelegate {

    var selectedIndex: IndexPath?

    // MARK: - Properties
    var stores: [Details] = [] // Array to store store details
    var filteredStores: [Details] = []
    var searchController: UISearchController?

    // MARK: - Logout Action
    @IBAction func Exit(_ sender: Any) {
        logout()
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stores"
        setupSearchController()

        // Fetch data from Firestore in real-time
        fetchStoresFromFirestore()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Firebase Firestore Fetch
    private func fetchStoresFromFirestore() {
        let db = Firestore.firestore()
        db.collection("Stores").addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching stores: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            self.stores = documents.compactMap { document -> Details? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let email = data["email"] as? String,
                      let num = data["number"] as? String,
                      let pass = data["password"] as? String,
                      let location = data["location"] as? String,
                      let web = data["website"] as? String,
                      let from = data["from"] as? String,
                      let to = data["to"] as? String,
                      let logoUrl = data["logoUrl"] as? String else {
                    return nil
                }

                // Initialize the Details object with the document ID
                return Details(
                    id: document.documentID, // Save Firestore document ID
                    name: name,
                    email: email,
                    num: num,
                    pass: pass,
                    image: UIImage(), // Placeholder for now
                    location: location,
                    web: web,
                    from: from,
                    to: to,
                    logoUrl: logoUrl
                )
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Placeholder Image
    private func placeholderImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.darkGray
            ]
            let text = "Image"
            let textSize = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: (100 - textSize.width) / 2, y: (100 - textSize.height) / 2), withAttributes: attributes)
        }
    }

    // MARK: - Search Controller Setup
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Stores"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Search Results Updating
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased(), !query.isEmpty else {
            filteredStores = stores
            tableView.reloadData()
            return
        }
        filteredStores = stores.filter { store in
            store.name.lowercased().contains(query) || store.location.lowercased().contains(query)
        }
        tableView.reloadData()
    }

    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (searchController?.isActive ?? false) ? 1 : stores.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchController?.isActive ?? false) ? filteredStores.count : 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchController?.isActive ?? false { return nil }
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreTableViewCell
        let store: Details
        if searchController?.isActive ?? false {
            store = filteredStores[indexPath.row]
        } else {
            store = stores[indexPath.section]
        }

        // Set store name
        cell.name.text = store.name

        // Dynamically load the image from logoUrl
        if let url = URL(string: store.logoUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.photo.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.photo.image = UIImage(named: "storefront") // Default placeholder image
                    }
                }
            }
        } else {
            cell.photo.image = UIImage(named: "storefront") // Default placeholder image if URL is invalid
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Get the store to delete
        let storeToDelete = stores[indexPath.section]

        // Create the delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }

            // Show confirmation alert before deleting
            let alert = UIAlertController(title: "Delete Store", message: "Are you sure you want to delete \"\(storeToDelete.name)\"?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completionHandler(false) // Cancel deletion
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                // Delete the document from Firestore
                let db = Firestore.firestore()
                db.collection("Stores").document(storeToDelete.id).delete { error in
                    if let error = error {
                        print("Error deleting store: \(error.localizedDescription)")
                        completionHandler(false)
                    } else {
                        print("Store deleted successfully from Firestore")

                        // Remove the store from the local array
                        self.stores.remove(at: indexPath.section)

                        // Reload the table view
                        tableView.deleteSections([indexPath.section], with: .automatic)
                        completionHandler(true)
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }

        deleteAction.backgroundColor = .red

        // Return the swipe actions configuration
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    // MARK: - AddTableViewControllerDelegate
    func didSaveStore(_ store: Details, editingIndex: IndexPath?) {
        if let editingIndex = editingIndex {
            stores[editingIndex.section] = store
        } else {
            stores.append(store)
        }
        tableView.reloadData()
    }

    @IBSegueAction func addEditStoreSegue(_ coder: NSCoder, sender: Any?) -> AddTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let storeToEdit = searchController?.isActive ?? false ? filteredStores[indexPath.row] : stores[indexPath.section]
            let viewController = AddTableViewController(coder: coder, store: storeToEdit)
            viewController?.editingIndex = indexPath
            viewController?.delegate = self
            return viewController
        } else {
            let viewController = AddTableViewController(coder: coder, store: nil)
            viewController?.delegate = self
            return viewController
        }
    }
}
