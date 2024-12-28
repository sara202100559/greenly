//
//  ProductInfoViewController.swift
//  Greenly
//
//  Created by BP-36-208-19 on 28/12/2024.
//

import UIKit

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
    
    // Struct to define the impact metrics of the product (e.g., environmental benefits).
    struct ImpactModel {
        var emission: String? // CO₂ emissions reduced
        var plasticReduction: String? // Plastic waste reduction
        var waterSaving: String? // Water savings
    }
    
    // Lifecycle method called when the view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        register() // Registers custom table view cells.
        tableView.reloadData() // Reloads the table view to display passed data.
    }
    
    // Function to register custom cell nibs with the table view.
    func register() {
        tableView.register(UINib(nibName: "ProductCell", bundle: .main), forCellReuseIdentifier: "productCell")
        tableView.register(UINib(nibName: "ProductDescriptionCell", bundle: .main), forCellReuseIdentifier: "productDescriptionCell")
        tableView.register(UINib(nibName: "ProductImgCell", bundle: .main), forCellReuseIdentifier: "productImgCell")
        tableView.register(UINib(nibName: "AddCartCell", bundle: .main), forCellReuseIdentifier: "addCartCell")
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension ProductInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Specifies the number of sections in the table view.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 // Five sections: image, title/price, description, metrics, and "Add to Cart" button.
    }
    
    // Specifies the number of rows in each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 4 // Section 3 (impact metrics) has 4 rows (title + 3 metrics)
        }
        return 1 // All other sections have a single row.
    }
    
    // Provides the cells for each row based on the section and row index.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // Section for displaying the product image.
            let cell = tableView.dequeueReusableCell(withIdentifier: "productImgCell", for: indexPath) as! ProductImgCell
            cell.productImg.image = IteamImag
            return cell
        case 1:
            // Section for product title and price.
            let cell = tableView.dequeueReusableCell(withIdentifier: "productDescriptionCell", for: indexPath) as! ProductDescriptionCell
            cell.titleLabel.text = productTitle
            cell.descriptionLabel.text = productPrice
            return cell
        case 2:
            // Section for product description.
            let cell = tableView.dequeueReusableCell(withIdentifier: "productDescriptionCell", for: indexPath) as! ProductDescriptionCell
            cell.titleLabel.text = "Description"
            cell.descriptionLabel.text = productDesc
            return cell
        case 3:
            // Section for impact metrics (multiple rows).
            return createProductCell(tableView, cellForRowAt: indexPath)
        case 4:
            // Section for "Add to Cart" button.
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCartCell", for: indexPath) as! AddCartCell
            cell.AddToCart.layer.cornerRadius = 10
            cell.AddToCart.layer.borderWidth = 1
            cell.buttonDelegate = self
            return cell
        default:
            return UITableViewCell() // Return an empty cell for undefined sections.
        }
    }
    
    // Helper function to create cells for the impact metrics section.
    func createProductCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
        switch indexPath.row {
        case 0:
            // Row for the title (Impact Metrics).
            cell.titleLabel.text = "Impact Metrics"
            cell.valueLabel.text = ""
        case 1:
            // Row for CO₂ emissions.
            cell.titleLabel.text = "CO₂ Emissions:"
            cell.valueLabel.text = metrics?.emission
        case 2:
            // Row for plastic waste reduction.
            cell.titleLabel.text = "Plastic Waste Reduction:"
            cell.valueLabel.text = metrics?.plasticReduction
        case 3:
            // Row for water savings.
            cell.titleLabel.text = "Water Savings:"
            cell.valueLabel.text = metrics?.waterSaving
        default:
            return UITableViewCell() // Return an empty cell for undefined rows.
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00001 // No header for the first section.
        }
        return 11
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

extension ProductInfoViewController: AddCartCellDelegate {
    func addToCartButtonTapped() {
        // Create a CartProduct instance for the current product
        let cartProduct = CartProduct(
            productId: Int.random(in: 1...1000), // Generate a random ID or use a unique identifier
            name: productTitle,
            price: Double(productPrice.replacingOccurrences(of: " BD", with: "")) ?? 0.0,
            image: "placeholder", // Replace with actual image name or URL if available
            quantity: 1, // Default quantity
            isChecked: false
        )

        // Add the product to the cart
        CartManager.shared.addProduct(cartProduct)

        // Show confirmation to the user
        let alertController = UIAlertController(title: "Product Added", message: "Your product has been added to the cart.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
