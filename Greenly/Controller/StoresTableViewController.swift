//
//  StoresTableViewController.swift
//  Greenly
//
//  Created by BP-36-201-18 on 01/12/2024.
//

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

import UIKit

class StoresTableViewController: UITableViewController, UISearchResultsUpdating, AddTableViewControllerDelegate {

    var selectedIndex: IndexPath?

    // MARK: - Properties
    var stores: [Details] = [] // Array to store store details
    var filteredStores: [Details] = []
    var searchController: UISearchController?

    //logout
    @IBAction func Exit(_ sender: Any) {
        logout()
    }

//    //cancel
//    @IBAction func cancle(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stores"
        setupSearchController()
        setupLongPressGesture()

        // Load saved stores or preload default data
        loadStores()
        if stores.isEmpty {
            preloadStores()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    

//private func setupNavigationBar() {
//    // Set the title
//    self.navigationItem.title = "Stores"
//    
//    // Add the left item with a system image
//    self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .add, target: self, action: #selector(addButtonTapped))
//    
//    // Add the right item with a custom image
//    let forwardArrowItem = UIBarButtonItem(systemImage: "rectangle.portrait.and.arrow.forward", target: self, action: #selector(forwardArrowTapped))
//    self.navigationItem.rightBarButtonItem = forwardArrowItem
//}


    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Preload Default Stores
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
    
    private func preloadStores() {
        let defaultImage = placeholderImage()

        let defaultStores = [
            Details(name: "EarthHero", email: "earthHero@gmail.com", num: "123-456-7890", pass: "EarthHero123", image: defaultImage, location: "Manama, Bahrain", web: "https://earthhero.com", from: "9 AM", to: "5 PM"),
            Details(name: "Ethical", email: "ethical@gmail.com", num: "987-654-3210", pass: "Ethical123", image: defaultImage, location: "Riffa, Bahrain", web: "https://ethical.com", from: "10 AM", to: "6 PM"),
            Details(name: "DoneGood", email: "donegood@gmail.com", num: "555-555-5555", pass: "DoneGood123", image: defaultImage, location: "Sitra, Bahrain", web: "https://donegood.com", from: "8 AM", to: "4 PM")
        ]

        stores.append(contentsOf: defaultStores)
        saveStores()
    }

    // MARK: - File Storage
    static var storesArchiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("stores").appendingPathExtension("plist")
    }

    func saveStores() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(stores)
            try data.write(to: StoresTableViewController.storesArchiveURL)
            print("Stores saved successfully.")
        } catch {
            print("Error saving stores: \(error)")
        }
    }

    func loadStores() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: StoresTableViewController.storesArchiveURL)
            stores = try decoder.decode([Details].self, from: data)
            print("Stores loaded successfully.")
        } catch {
            print("Error loading stores: \(error)")
        }
    }

    // MARK: - Setup Search Controller
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Stores"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Setup Long Press Gesture
    func setupLongPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        let touchPoint = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            let store = searchController?.isActive ?? false ? filteredStores[indexPath.row] : stores[indexPath.section]
            presentDeleteConfirmation(for: store, at: indexPath)
        }
    }

    func presentDeleteConfirmation(for store: Details, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete Store",
            message: "Are you sure you want to delete \(store.name)?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteStore(at: indexPath)
        }))
        present(alert, animated: true, completion: nil)
    }

    private func deleteStore(at indexPath: IndexPath) {
        if searchController?.isActive ?? false {
            let storeToRemove = filteredStores[indexPath.row]
            if let originalIndex = stores.firstIndex(where: { $0.name == storeToRemove.name }) {
                stores.remove(at: originalIndex)
            }
            filteredStores.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            stores.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        }
        saveStores()
    }

    // MARK: - UISearchResultsUpdating
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
        cell.name.text = store.name
        cell.photo.image = store.image
        return cell
    }

    // MARK: - AddTableViewControllerDelegate
    func didSaveStore(_ store: Details, editingIndex: IndexPath?) {
        if let editingIndex = editingIndex {
            stores[editingIndex.section] = store
            if searchController?.isActive ?? false {
                filteredStores[editingIndex.row] = store
            }
        } else {
            stores.append(store)
            if searchController?.isActive ?? false {
                filteredStores.append(store)
            }
        }
        saveStores()
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
