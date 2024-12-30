import UIKit

// This view controller manages the cart items in a table view format.
class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! // Outlet connected to the table view in the storyboard.
    
    var totalPrice = 0.0
    var isAllProductSelected = true
    var storeName = "Package Free"

    
    
    var cartProducts: [CartProduct] = []
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        registerCells() // Register custom cells with the table view.
//        cartProducts.append(contentsOf: cartItems)
//        calculateTotalPrice()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        cartProducts = CartManager.shared.getCartProducts() // Load products from CartManager
        calculateTotalPrice()
    }

    
    // Function to register custom cell nibs.
    func registerCells() {
        tableView.register(UINib(nibName: "ItemCell", bundle: .main), forCellReuseIdentifier: "ItemCell")
        tableView.register(UINib(nibName: "SubCell", bundle: .main), forCellReuseIdentifier: "SubCell")
        tableView.register(UINib(nibName: "CheckoutCell", bundle: .main), forCellReuseIdentifier: "CheckoutCell")
        tableView.register(UINib(nibName: "StoreNameCell", bundle: .main), forCellReuseIdentifier: "StoreNameCell")
    }

    //Calulating Total Price
    func calculateTotalPrice() {
        totalPrice = cartProducts.reduce(0.0, { partialResult, item in
            var itemPrice = ((item.price ?? 0) * Double(item.quantity ?? 1))
            if !(item.isChecked ?? false) {
                itemPrice = 0
            }
            return partialResult + itemPrice
        })
    }
    
    //Validation for Apply All
    @discardableResult
    func isAllItemsChecked() -> Bool {
        var isAllChecked = true
        for product in self.cartProducts {
            if !(product.isChecked ?? false) {
                isAllChecked = false
                break
            }
        }
        isAllProductSelected = isAllChecked
        return isAllChecked
    }
    
    func isAnyOfTheItemChecked() -> Bool {
        return cartProducts.filter({$0.isChecked ?? false}).count > 0
    }
}

// Extension to conform to UITableViewDelegate and UITableViewDataSource protocols.
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let productsCount = cartProducts.count
         
        return productsCount > 0 ? 3 : 1 // Single section for cart items.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Store Name
        } else if section == 2 {
            return 2 // Apply All cell + checkout
        }
        return cartProducts.count // Number of rows equals the number of cart items.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreNameCell", for: indexPath) as! StoreNameCell
            cell.nameLabel.text = storeName
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            let item = cartProducts[indexPath.row]
            
            // Configure the cell with cart item data.
            cell.itemNameLabel.text = item.name
            cell.itemPriceLabel.text = String(format: "%.2f BD", item.price ?? 0)
            if let imageName = item.image {
                cell.itemImageView.image = UIImage(named: imageName)
            }
            cell.itemImageView.cornerRadius = 8
            cell.quantity = item.quantity ?? 1
            cell.isChecked = item.isChecked ?? false
            if item.isChecked == false {
                isAllProductSelected = false
            }
            // Handle quantity changes. - Firebase update
            cell.onQuantityChange = { [weak self] newQuantity in
                if newQuantity <= 0 {
                    self?.cartProducts.remove(at: indexPath.row)
                    self?.calculateTotalPrice() // Recalculate total price after removing the item
                    self?.tableView.reloadData()
                } else {
                    self?.cartProducts[indexPath.row].quantity = newQuantity
                    //print("Item \(item.name) quantity updated to \(newQuantity)")
                    self?.calculateTotalPrice()
                    let totalPriceRowIndex = IndexPath(row: 0, section: 2)
                    tableView.reloadRows(at: [totalPriceRowIndex], with: .automatic)
                }
            }
            
            // Handle checkbox state changes.- Firebase update
            cell.onCheckboxToggle = { [weak self] isChecked in
                self?.cartProducts[indexPath.row].isChecked = isChecked
                //print("Item \(item.name) checkbox state: \(isChecked)")
                self?.calculateTotalPrice()
                self?.tableView.reloadData()
            }
            
            return cell
        case 2:
            if indexPath.row == 0 {
                //Apply All cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath) as! SubCell
                cell.setUpUI()
                isAllItemsChecked()
                cell.isChecked = isAllProductSelected
                cell.totalPriceLabel.text = "Total :  \(totalPrice) BD"
                
                cell.onCheckboxToggle = { [weak self] isChecked in
                    self?.isAllProductSelected = isChecked
                    //- Firebase update
                    self?.cartProducts = (self?.cartProducts.compactMap({ item in
                        var item = item
                        item.isChecked = isChecked
                        return item
                    })) ?? []
                    self?.calculateTotalPrice()
                    self?.tableView.reloadData()
                    print("All items checkbox state: \(isChecked)")
                }

                return cell
            } else {
                //checkout
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell
                cell.CheckoutButton.layer.cornerRadius = 10
                cell.CheckoutButton.layer.borderWidth = 1
                cell.CheckoutButton.isEnabled = self.isAnyOfTheItemChecked()
                cell.checkOutButtonTapped = {
                    self.performSegue(withIdentifier: "checkOutNav", sender: nil)
                }
                return cell
            }

            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Adjust as needed for your cell layout.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let checkOutVC = segue.destination as? CheckoutViewController
        checkOutVC?.totalPrice = totalPrice
        checkOutVC?.products = self.cartProducts.filter({$0.isChecked ?? false})
        // To pass the data from CartViewController to CheckoutViewController
        // checkOutVC.data = data //data ->> content need to be passed
    }
}
