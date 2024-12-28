//
//  ManageInventoryVC.swift
//  Greenly
//
//  Created by Sumaya Janahi on 21/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class ManageInventoryVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var filteredProducts: [Product] = []
    var products: [Product] = []
    var storeId: String? // Store ID to be passed or updated
    let db = Firestore.firestore() // Firestore database reference

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manage Inventory"
        //storeId = fetchStoreIdFromSession()
        storeId = "exampleStoreId123"

        // Set up segmented control change action
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

        // Add long press gesture recognizer to table view for editing
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        tableView.addGestureRecognizer(longPressGesture)

        // Navigation bar add button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))

        // Register table view cell
        let nib = UINib(nibName: "ProductTVC", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductTVC")

        tableView.delegate = self
        tableView.dataSource = self

        // Load products from Firestore
        loadProductsFromFirestore()
    }

    private func fetchStoreIdFromSession() -> String? {
        // Fetch the storeId from session or backend
        return UserDefaults.standard.string(forKey: "storeId") // Replace with actual logic
    }
    

    @objc func segmentedControlChanged() {
        // Call function to filter products based on the selected category
        filterProducts()
        tableView.reloadData() // Reload the table view to show the filtered data
    }

    func filterProducts() {
        // Filter products based on the selected category
        switch segmentedControl.selectedSegmentIndex {
        case 0: // "All"
            filteredProducts = products
        case 1: // "Kitchen"
            filteredProducts = products.filter { $0.category.lowercased() == "kitchen" }
        case 2: // "SelfCare"
            filteredProducts = products.filter { $0.category.lowercased() == "cleaning" }
        case 3: // "Cleaning"
            filteredProducts = products.filter { $0.category.lowercased() == "self care" }
        default:
            filteredProducts = products
        }
    }

    // Helper method to check if the product should be included in the filtered list
    func shouldIncludeProductInFilteredList(_ product: Product) -> Bool {
        switch segmentedControl.selectedSegmentIndex {
        case 0: // "All" category, show all products
            return true
        case 1: // "Kitchen"
            return product.category.lowercased() == "kitchen"
        case 2: // "Self Care"
            return product.category.lowercased() == "self care"
        case 3: // "Cleaning"
            return product.category.lowercased() == "cleaning"
        default:
            return false
        }
    }

    @objc func addProduct() {
        let vc = UIStoryboard(name: "StoreOwner", bundle: nil).instantiateViewController(withIdentifier: "AddProductTableViewController") as! AddProductTableViewController
        vc.delegate = self
        vc.product = nil
        vc.editingIndex = nil
        vc.storeId = self.storeId // Pass storeId
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                let productToEdit = filteredProducts[indexPath.row]

                let vc = UIStoryboard(name: "StoreOwner", bundle: nil).instantiateViewController(withIdentifier: "AddProductTableViewController") as! AddProductTableViewController
                vc.delegate = self
                vc.product = productToEdit
                vc.editingIndex = indexPath
                vc.storeId = productToEdit.storeId ?? self.storeId // Use the product's storeId or fallback
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

//    @objc func addProduct() {
//        // Navigate to AddProductTableViewController in add mode
//        let vc = UIStoryboard(name: "StoreOwner", bundle: nil).instantiateViewController(withIdentifier: "AddProductTableViewController") as! AddProductTableViewController
//        vc.delegate = self
//        vc.product = nil
//        vc.editingIndex = nil
//        vc.storeId = self.storeId
//        navigationController?.pushViewController(vc, animated: true)
//    }

    func loadProductsFromFirestore() {
        db.collection("Products").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
                return
            }

            self.products = querySnapshot?.documents.compactMap { doc -> Product? in
                let data = doc.data()
                return Product(
                    name: data["name"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    category: data["category"] as? String ?? "",
                    price: data["price"] as? String ?? "",
                    image: UIImage(named: "placeholder") ?? UIImage(), // Placeholder image to avoid nil issues
                    co2Emissions: data["co2Emissions"] as? String ?? "",
                    plasticWaste: data["plasticWaste"] as? String ?? "",
                    waterSaved: data["waterSaved"] as? String ?? "",
                    quantity: data["quantity"] as? String ?? "",
                    storeId: data["storeId"] as? String ?? "",
                    imageUrl: data["imageUrl"] as? String ?? ""
                )
            } ?? []

            self.filterProducts()
            self.tableView.reloadData()
        }
    }

    func saveProductToFirestore(product: Product) {
        guard let storeId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated")
            return
        }

        let productData: [String: Any] = [
            "name": product.name,
            "description": product.description,
            "category": product.category,
            "price": product.price,
            "co2Emissions": product.co2Emissions,
            "plasticWaste": product.plasticWaste,
            "waterSaved": product.waterSaved,
            "quantity": product.quantity,
            "storeId": storeId, // Use the authenticated user's UID
            "imageUrl": product.imageUrl
        ]

        db.collection("Products").addDocument(data: productData) { error in
            if let error = error {
                print("Error saving product to Firestore: \(error)")
            } else {
                print("Product saved successfully to Firestore.")
            }
        }
    }


    func saveDeletedProductFromFirestore(_ product: Product) {
        db.collection("Products").whereField("name", isEqualTo: product.name).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error finding product to delete: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else { return }
            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting product from Firestore: \(error)")
                    } else {
                        print("Product deleted successfully from Firestore.")
                    }
                }
            }
        }
    }
}

// UITableViewDelegate and UITableViewDataSource extension
extension ManageInventoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTVC", for: indexPath) as! ProductTVC
        let product = filteredProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let productToDelete = filteredProducts[indexPath.row]
            filteredProducts.remove(at: indexPath.row)
            if let index = products.firstIndex(where: { $0.name == productToDelete.name }) {
                products.remove(at: index)
            }

            saveDeletedProductFromFirestore(productToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// AddProductTableViewControllerDelegate extension
extension ManageInventoryVC: AddProductTableViewControllerDelegate {
    func didSaveProduct(_ product: Product, editingIndex: IndexPath?) {
        if let editingIndex = editingIndex {
            // Update the existing product
            products[editingIndex.row] = product
            filteredProducts[editingIndex.row] = product
        } else {
            // Add the new product
            products.append(product)

            // Check if the new product matches the current filter
            if shouldIncludeProductInFilteredList(product) {
                filteredProducts.append(product)
            }
        }

        filterProducts()
        tableView.reloadData()
        saveProductToFirestore(product: product)
    }

    func didSetStoreId(_ storeId: String) {
        self.storeId = storeId // Update storeId in ManageInventoryVC
    }
}
