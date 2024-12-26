//
//  StoresTableViewController.swift
//  Greenly
//
//  Created by BP-36-201-18 on 01/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

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


class StoresTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBAction func Exit(_ sender: Any) {
            logout()
        }
    
    // MARK: - Properties
    var stores: [Details] = [] // Array to store store details
    var filteredStores: [Details] = []
    var searchController: UISearchController?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stores"
        setupSearchController()
        fetchStoresFromFirestore()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    // MARK: - Firebase Firestore Fetch
    private func fetchStoresFromFirestore() {
        let db = Firestore.firestore()
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

                // If the password exists in the document, set it; otherwise, leave it empty
                let password = data["password"] as? String ?? ""

                return Details(
                    id: document.documentID,
                    name: name,
                    email: email,
                    num: num,
                    pass: password,
                    image: UIImage(),
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

    
    // MARK: - Search Controller Setup
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Stores"
        navigationItem.searchController = searchController
    }
    
    // MARK: - Search Results Updating
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased(), !query.isEmpty else {
            filteredStores = stores
            tableView.reloadData()
            return
        }
        filteredStores = stores.filter { $0.name.lowercased().contains(query) || $0.location.lowercased().contains(query) }
        tableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchController?.isActive ?? false ? 1 : stores.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController?.isActive ?? false ? filteredStores.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreTableViewCell
        let store = searchController?.isActive ?? false ? filteredStores[indexPath.row] : stores[indexPath.section]
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
    
    func checkAdminStatus(completion: @escaping (Bool) -> Void) {
        Auth.auth().currentUser?.getIDTokenResult { (result, error) in
            if let error = error {
                print("Error fetching token result: \(error.localizedDescription)")
                completion(false)
                return
            }
            let isAdmin = result?.claims["admin"] as? Bool ?? false
            print("Is admin: \(isAdmin)")
            completion(isAdmin)
        }
    }

    
    // MARK: - Swipe to Delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let storeToDelete = stores[indexPath.section]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }

            let alert = UIAlertController(
                title: "Delete Store",
                message: "Are you sure you want to delete \"\(storeToDelete.name)\"?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completionHandler(false)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                let db = Firestore.firestore()
                db.collection("Stores").document(storeToDelete.id).delete { error in
                    if let error = error {
                        print("Error deleting store: \(error.localizedDescription)")
                        AlertHelper.showAlert(on: self, title: "Error", message: "Failed to delete store: \(error.localizedDescription)")
                        completionHandler(false)
                    } else {
                        print("Store deleted successfully!")
                        self.stores.remove(at: indexPath.section)
                        DispatchQueue.main.async {
                            tableView.deleteSections([indexPath.section], with: .automatic)
                            completionHandler(true)
                        }
                    }
                }
            }))
            self.present(alert, animated: true)
        }

        // Wrap the delete action in UISwipeActionsConfiguration
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
            let storeToEdit = stores[indexPath.section]
            return AddTableViewController(coder: coder, store: storeToEdit)
        } else {
            return AddTableViewController(coder: coder, store: nil)
        }
    }
}
