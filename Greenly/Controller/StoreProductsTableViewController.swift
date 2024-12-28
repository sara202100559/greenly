//
//  StoreProductsTableViewController.swift
//  Greenly
//
//  Created by Sumaya Janahi on 27/12/2024.
//

import UIKit
import FirebaseFirestore

class StoreProductsTableViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var filteredProducts: [Product] = []
    var products: [Product] = []
    let db = Firestore.firestore() // Firestore database reference

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Store Products"

        // Setup segmented control
        segmentedControl?.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

        // Register custom cell
        let nib = UINib(nibName: "ProductTVCcust", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductTVCcust")

        tableView.delegate = self
        tableView.dataSource = self

        // Fetch products from Firestore
        loadProductsFromFirestore()
    }

    // MARK: - Fetch Products from Firestore
    func loadProductsFromFirestore() {
        db.collection("Products")
            .getDocuments { [weak self] (querySnapshot, error) in
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
                        image: UIImage(named: "placeholder") ?? UIImage(),
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

    // MARK: - Segmented Control Handler
    @objc func segmentedControlChanged() {
        filterProducts()
        tableView.reloadData()
    }

    func filterProducts() {
        // Filter products based on the selected category
        switch segmentedControl?.selectedSegmentIndex {
        case 0: // "All"
            filteredProducts = products
        case 1: // "Kitchen"
            filteredProducts = products.filter { $0.category.lowercased() == "kitchen" }
        case 2: // "Cleaning"
            filteredProducts = products.filter { $0.category.lowercased() == "cleaning" }
        case 3: // "Self Care"
            filteredProducts = products.filter { $0.category.lowercased() == "self care" }
        default:
            filteredProducts = products
        }
    }
}

//// MARK: - UITableViewDelegate and UITableViewDataSource
//extension StoreProductsTableViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredProducts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTVCcust", for: indexPath) as! ProductTVCcust
//        let product = filteredProducts[indexPath.row]
//        cell.configure(with: product)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension StoreProductsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTVCcust", for: indexPath) as! ProductTVCcust
        let product = filteredProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedProduct = filteredProducts[indexPath.row]
        let storyboard = UIStoryboard(name: "ProductDetails", bundle: nil)
        if let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoViewController") as? ProductInfoViewController {
            
            productInfoVC.productTitle = selectedProduct.name
            productInfoVC.productPrice = "\(selectedProduct.price) BD"
            productInfoVC.productDesc = selectedProduct.description
            productInfoVC.metrics = ProductInfoViewController.ImpactModel(
                emission: selectedProduct.co2Emissions,
                plasticReduction: selectedProduct.plasticWaste,
                waterSaving: selectedProduct.waterSaved
            )
            if let imageUrl = URL(string: selectedProduct.imageUrl!) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            productInfoVC.IteamImag = image
                            self.navigationController?.pushViewController(productInfoVC, animated: true)
                        }
                    }
                }
            } else {
                self.navigationController?.pushViewController(productInfoVC, animated: true)
            }
        }
    }

}

