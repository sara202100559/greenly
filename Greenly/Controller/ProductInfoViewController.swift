//
//  ProductInfoViewController.swift
//  Greenly
//
//  Created by BP-36-208-19 on 28/12/2024.
//

import UIKit
import Firebase

// This view controller displays detailed product information in a table view format.
class ProductInfoViewController: UIViewController {
    
    // IBOutlet connected to the table view in the storyboard.
    @IBOutlet weak var tableView: UITableView!
    
    // Properties to hold dynamically passed product data
    var productTitle: String = ""
    var productPrice: String = ""
    var productDesc: String = ""
    var IteamImag: UIImage? = UIImage(named: "placeholder") // Default placeholder image
    var metrics: ImpactModel? // Impact metrics for the product
    var category: String = "" // Category of the product
    var suggestedProducts: [Product] = [] // To store suggested products

    // Struct to define the impact metrics of the product (e.g., environmental benefits).
    struct ImpactModel {
        var emission: String? // CO₂ emissions reduced
        var plasticReduction: String? // Plastic waste reduction
        var waterSaving: String? // Water savings
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        register() // Registers custom table view cells.
        loadSuggestedProducts() // Fetches suggested products.

        // Enable dynamic row height
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

    // Function to register custom cell nibs with the table view.
    func register() {
        tableView.register(UINib(nibName: "ProductCell", bundle: .main), forCellReuseIdentifier: "productCell")
        tableView.register(UINib(nibName: "ProductDescriptionCell", bundle: .main), forCellReuseIdentifier: "productDescriptionCell")
        tableView.register(UINib(nibName: "ProductImgCell", bundle: .main), forCellReuseIdentifier: "productImgCell")
        tableView.register(UINib(nibName: "AddCartCell", bundle: .main), forCellReuseIdentifier: "addCartCell")
        tableView.register(UINib(nibName: "SuggestedProducts", bundle: .main), forCellReuseIdentifier: "suggestedProductsCell")
    }

    // Function to load suggested products from Firestore.
    func loadSuggestedProducts() {
        let db = Firestore.firestore()
        db.collection("products").whereField("category", isEqualTo: category).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching suggested products: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else { return }
            self.suggestedProducts = documents.compactMap { document -> Product? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let description = data["description"] as? String,
                      let category = data["category"] as? String,
                      let price = data["price"] as? String,
                      let imageUrl = data["imageUrl"] as? String else { return nil }
                return Product(
                    name: name,
                    description: description,
                    category: category,
                    price: price,
                    image: UIImage(),
                    co2Emissions: "",
                    plasticWaste: "",
                    waterSaved: "",
                    quantity: "",
                    storeId: nil,
                    imageUrl: imageUrl
                )
            }.filter { $0.name != self.productTitle } // Exclude the current product

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension ProductInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6 // Including the Suggested Products section.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 4 // Metrics rows.
        }
        if section == 5 { // Suggested Products Section.
            return suggestedProducts.isEmpty ? 0 : 1 // Return 1 row if products exist, otherwise 0.
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "productImgCell", for: indexPath) as! ProductImgCell
            cell.productImg.image = IteamImag
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "productDescriptionCell", for: indexPath) as! ProductDescriptionCell
            cell.titleLabel.text = productTitle
            cell.descriptionLabel.text = productPrice
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "productDescriptionCell", for: indexPath) as! ProductDescriptionCell
            cell.titleLabel.text = "Description"
            cell.descriptionLabel.text = productDesc
            return cell
        case 3:
            return createProductCell(tableView, cellForRowAt: indexPath)
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCartCell", for: indexPath) as! AddCartCell
            cell.AddToCart.layer.cornerRadius = 10
            cell.AddToCart.layer.borderWidth = 1
            cell.buttonDelegate = self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "suggestedProductsCell", for: indexPath) as! SuggestedProductsCell
            cell.configure(with: suggestedProducts)
            cell.onProductTap = { [weak self] product in
                guard let self = self else { return }
                self.navigateToProductDetail(product)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }

    func createProductCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Impact Metrics"
            cell.valueLabel.text = ""
        case 1:
            cell.titleLabel.text = "CO₂ Emissions:"
            cell.valueLabel.text = metrics?.emission
        case 2:
            cell.titleLabel.text = "Plastic Waste Reduction:"
            cell.valueLabel.text = metrics?.plasticReduction
        case 3:
            cell.titleLabel.text = "Water Savings:"
            cell.valueLabel.text = metrics?.waterSaving
        default:
            return UITableViewCell()
        }
        return cell
    }

    func navigateToProductDetail(_ product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoViewController") as! ProductInfoViewController
        productInfoVC.productTitle = product.name
        productInfoVC.productPrice = product.price
        productInfoVC.productDesc = product.description
        productInfoVC.IteamImag = nil // Update if product image is available.
        productInfoVC.category = product.category
        navigationController?.pushViewController(productInfoVC, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.00001 : 11
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

// MARK: - AddCartCellDelegate
extension ProductInfoViewController: AddCartCellDelegate {
    func addToCartButtonTapped() {
        // Create a CartProduct instance for the current product.
        let cartProduct = CartProduct(
            productId: Int.random(in: 1...1000), // Generate a random ID or use a unique identifier.
            name: productTitle,
            price: Double(productPrice.replacingOccurrences(of: " BD", with: "")) ?? 0.0,
            image: "placeholder", // Replace with actual image name or URL if available.
            quantity: 1, // Default quantity.
            isChecked: false
        )

        // Add the product to the cart.
        CartManager.shared.addProduct(cartProduct)

        // Show confirmation to the user.
        let alertController = UIAlertController(title: "Product Added", message: "Your product has been added to the cart.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
