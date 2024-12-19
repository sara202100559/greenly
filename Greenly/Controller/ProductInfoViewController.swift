import UIKit

// This view controller displays detailed product information in a table view format.
class ProductInfoViewController: UIViewController {
    
    // IBOutlet connected to the table view in the storyboard.
    @IBOutlet weak var tableView: UITableView!
    
    // Constants to hold product title, price, and description.
    let productTitle = "Stainless steel container" // The title of the product.
    let productPrice = "3.0 BD" // The price of the product.
    let productDesc = "A durable, sustainable container for food storage." // Product description.
    
    // Placeholder image for the product.
    let IteamImag = UIImage(named: "checkbox.png") // Example product image.
    
    // Struct to define the impact metrics of the product (e.g., environmental benefits).
    struct ImpactModel {
        var emission: String? // CO₂ emissions reduced.
        var plasticReduction: String? // Plastic waste reduction.
        var waterSaving: String? // Water savings.
    }
    
    // Instance of ImpactModel holding specific metrics for this product.
    var metrics = ImpactModel(emission: "10 Kg", plasticReduction: "2 Kg", waterSaving: "30 liters")
    
    // Lifecycle method called when the view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        register() // Registers custom table view cells.
    }
    
    // Function to register custom cell nibs with the table view.
    func register() {
        tableView.register(UINib(nibName: "ProductCell", bundle: .main), forCellReuseIdentifier: "productCell")
        tableView.register(UINib(nibName: "ProductDescriptionCell", bundle: .main), forCellReuseIdentifier: "productDescriptionCell")
        tableView.register(UINib(nibName: "ProductImgCell", bundle: .main), forCellReuseIdentifier: "productImgCell")
        tableView.register(UINib(nibName: "AddCartCell", bundle: .main), forCellReuseIdentifier: "addCartCell")
        // You can add additional cells if required, e.g., "AddCartCell".
        
    }
}

// Extension to conform to UITableViewDelegate and UITableViewDataSource protocols.
extension ProductInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Specifies the number of sections in the table view.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 // Five sections: image, title/price, description, metrics and Add to cart button.
    }
    
    // Specifies the number of rows in each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 4 // Section 3 (impact metrics) has three rows. + 1 row for title
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
            cell.descriptionLabel.text = productDesc
            return cell
        case 3:
            // Section for impact metrics (multiple rows).
            return createProductCell(tableView, cellForRowAt: indexPath)
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCartCell", for: indexPath) as! AddCartCell
            cell.AddToCart.layer.cornerRadius = 10
            cell.AddToCart.layer.borderWidth = 1
//            cell.AddToCart.layer.borderColor = UIColor(red: 44, green: 44, blue: 44, alpha: 1).cgColor
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
            // Row for Title(Impact Metrics)
            cell.titleLabel.text = "Impact Metrics"
            cell.valueLabel.text = ""
        case 1:
            // Row for CO₂ emissions.
            cell.titleLabel.text = "CO₂ Emissions:"
            cell.valueLabel.text = metrics.emission
        case 2:
            // Row for plastic waste reduction.
            cell.titleLabel.text = "Plastic Waste Reduction:"
            cell.valueLabel.text = metrics.plasticReduction
        case 3:
            // Row for water savings.
            cell.titleLabel.text = "Water Savings:"
            cell.valueLabel.text = metrics.waterSaving
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
            return 0.00001
        }
        return 11
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

extension ProductInfoViewController: AddCartCellDelegate {
    func addToCartButtonTapped() {
        
        let alertControllerr = UIAlertController(title: "Your product has been added to cart!", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertControllerr.addAction(okAction)
        
        present(alertControllerr, animated: true)
    }
    
    
}
