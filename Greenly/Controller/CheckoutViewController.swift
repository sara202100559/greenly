//  CheckoutViewController.swift
//  MyProject
//
//  Created on 13/12/24.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    enum PaymentMethod: String {
        case cash
        case card
        case none
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    var totalPrice = 0.0
    var products: [CartProduct]?
    var selectedPaymentType: PaymentMethod = .none
    
    var selectedAddress = [String: String]()
    
    var savedAddresses = [[String: String]]() {
        didSet {
            if savedAddresses.count == 1 {
                self.selectedAddress = savedAddresses[0]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.register()
        tableview.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let allAddresses = UserDefaults.standard.array(forKey: "savedAddresses") as? [[String: String]] {
            savedAddresses.removeAll()
            savedAddresses.append(contentsOf: allAddresses)
            tableview.reloadData()
            updateCheckoutButtonState() // Ensure button state is updated
        }
    }
    
    func register() {
        tableview.register(UINib(nibName: "CheckoutTableViewCell", bundle: .main), forCellReuseIdentifier: "CheckoutTableViewCell")
        tableview.register(UINib(nibName: "CheckoutCell", bundle: .main), forCellReuseIdentifier: "CheckoutCell")
        tableview.register(UINib(nibName: "ProductDescriptionCell", bundle: .main), forCellReuseIdentifier: "productDescriptionCell")
        tableview.register(UINib(nibName: "SubCell", bundle: .main), forCellReuseIdentifier: "SubCell")
        tableview.register(UINib(nibName: "SavedAddressCell", bundle: .main), forCellReuseIdentifier: "savedAddressCell")
    }
    
    func processOrder() {
        guard let selectedProducts = products else { return }
        
        // Generate order details
        let orderId = generateOrderID() // Use the new generateOrderID() method
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateTime = formatter.string(from: currentDate)
        
        // Prepare order items
        let orderItems = selectedProducts.map { (product) in
            return OrderItem(
                name: product.name ?? "Unnamed Product", // Use a default value if name is nil
                price: "\(String(describing: product.price))",
                quantity: "\(product.quantity ?? 1)"
            )
        }
        
        // Create a new order
        let newOrder = Order(
            id: orderId,
            status: .pending,
            date: dateTime,
            price: totalPrice,
            ownerName: "Store Name", // Replace with actual store name if available
            feedback: nil,
            rating: nil,
            storeName: selectedAddress["name"] ?? "N/A", // Ensure correct store name is populated
            items: orderItems,
            paymentMethod: selectedPaymentType.rawValue
        )
        
        // Save the order to UserDefaults
        var orders = UserDefaults.standard.loadOrders()
        orders.append(newOrder)
        UserDefaults.standard.saveOrders(orders)
        
        // Show confirmation alert
        let alert = UIAlertController(
            title: "Order Placed",
            message: "Your order has been placed successfully!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
        updateImpactTracker()
    }
    
    private func updateImpactTracker() {
        // Reset the impact data to default values
        ImpactData.shared.resetToDefaultValues()
        
        // Refresh the chart in ChartViewController
        if let chartVC = self.navigationController?.viewControllers.compactMap({ $0 as? ChartViewController }).first {
            chartVC.refreshChart()
        }
    }
    
    private func generateOrderID() -> String {
        let orderCountKey = "orderCountKey"
        let currentCount = UserDefaults.standard.integer(forKey: orderCountKey) // Default is 0
        let newCount = currentCount + 1
        UserDefaults.standard.set(newCount, forKey: orderCountKey)
        return String(newCount)
    }
    
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return savedAddresses.count + 2 // Add row for saved address if available
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return createTitleCell(tableView, cellForRowAt: indexPath, title: "Saved Addresses")
            } else if tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
                cell.cellBackgroundView.cornerRadius = 4
                cell.titleLabel.text = "Add New Address"
                cell.leftButton.setImage(UIImage(systemName: "plus"), for: .normal)
                cell.leftButtonTapped = {
                    self.performSegue(withIdentifier: "addressNav", sender: nil)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "savedAddressCell", for: indexPath) as! SavedAddressCell
                cell.cellBackgroundView.cornerRadius = 4
                
                // Titles mapping for each field
                let titles = ["Building Number", "Road Number", "Block Number"]
                
                // Reset cell content to avoid duplication
                cell.AddNameLabel.text = nil
                cell.areaLabel.text = nil
                cell.buildLabel.text = nil
                cell.roadLabel.text = nil
                cell.blockLabel.text = nil
                cell.isChecked = false
                
                // Set the address
                let address = savedAddresses[indexPath.row - 1]
                cell.AddNameLabel.text = address["name"]
                cell.areaLabel.text = address["area"]
                cell.buildLabel.text = "\(titles[0]): \(address["buildingNumber"] ?? "")"
                cell.roadLabel.text = "\(titles[1]): \(address["roadNumber"] ?? "")"
                cell.blockLabel.text = "\(titles[2]): \(address["blockNumber"] ?? "")"
                cell.cellAddress = address
                cell.isChecked = address["name"] == selectedAddress["name"]
                
                cell.onCheckboxToggle = { status in
                    if status {
                        self.selectedAddress = cell.cellAddress
                    } else {
                        self.selectedAddress = [:]
                    }
                    self.tableview.reloadData()
                }
                
                cell.onDelete = {
                    if let index = self.savedAddresses.firstIndex(of: cell.cellAddress) {
                        self.savedAddresses.remove(at: index)
                        UserDefaults.standard.set(self.savedAddresses, forKey: "savedAddresses")
                        
                        // Clear selectedAddress if the deleted address was selected
                        if self.selectedAddress == cell.cellAddress {
                            self.selectedAddress = [:]
                        }
                        
                        // Show a confirmation alert
                        let alert = UIAlertController(
                            title: "Deleted",
                            message: "Address has been deleted!",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.tableview.reloadData()
                            self.updateCheckoutButtonState() // Update the checkout button state
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                return cell
            }
            
        case 1:
            return createPaymentMethodSection(tableView, cellForRowAt: indexPath)
        case 2:
            if indexPath.row == 0 {
                return createTitleCell(tableView, cellForRowAt: indexPath, title: "Order Summary")
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath) as! SubCell
                cell.cellBackgroundView.cornerRadius = 4
                let productCount = products?.reduce(0, { $0 + ($1.quantity ?? 1) }) ?? 0 // Fixed here
                cell.checkButton.isHidden = true
                cell.titleLabel.text = "(\(productCount)) Items"
                cell.totalPriceLabel.text = "Total :  \(totalPrice) BD"
                cell.cellBackgroundView.backgroundColor = .white
                cell.contentView.backgroundColor = .clear
                cell.cellBackgroundViewLeadingConstraint.constant = 32
                cell.cellBackgroundViewTrailingConstraint.constant = 32
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell
            cell.CheckoutButton.layer.cornerRadius = 10
            cell.CheckoutButton.layer.borderWidth = 1
            
            // Update the button title dynamically based on payment type
            let buttonTitle = self.selectedPaymentType == .card ? "Confirm & Pay" : "Place Order"
            cell.CheckoutButton.setTitle(buttonTitle, for: .normal)
            
            // Enable the button only if a payment type is selected and an address is chosen
            cell.CheckoutButton.isEnabled = (self.selectedPaymentType != .none) && !self.selectedAddress.isEmpty
            
            cell.checkOutButtonTapped = {
                if self.selectedPaymentType == .card {
                    // Navigate to ProcessPaymentViewController
                    self.performSegue(withIdentifier: "processPaymentSegue", sender: nil)
                } else if self.selectedPaymentType == .cash {
                    // Show confirmation alert for cash on delivery
                    let alert = UIAlertController(
                        title: "Confirmation",
                        message: "Are you sure you want to place this order?",
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        self.processOrder()
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func updateCheckoutButtonState() {
        // Find the CheckoutCell and update its button state
        let checkoutIndexPath = IndexPath(row: 0, section: 3)
        if let cell = tableview.cellForRow(at: checkoutIndexPath) as? CheckoutCell {
            cell.CheckoutButton.isEnabled = (self.selectedPaymentType != .none) && !self.selectedAddress.isEmpty
        }
    }
    
    func createTitleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, title: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productDescriptionCell", for: indexPath) as! ProductDescriptionCell
        cell.titleLabel.text = title
        cell.descriptionLabel.text = ""
        cell.titleLableLeadingConstraint.constant = 29
        return cell
    }
    
    func createPaymentMethodSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return createTitleCell(tableView, cellForRowAt: indexPath, title: "Payment Method")
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
            cell.cellBackgroundView.cornerRadius = 4
            cell.titleLabel.text = "Cash on Delivery"
            
            cell.isChecked = self.selectedPaymentType == .cash
            let imageForButton = cell.isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
            cell.leftButton.setImage(imageForButton, for: .normal)
            
            cell.leftButtonTapped = {
                cell.isChecked.toggle()
                self.selectedPaymentType = cell.isChecked ? .cash : .none
                self.tableview.reloadRows(at: [IndexPath(row: 2, section: indexPath.section), IndexPath(row: 0, section: 3)], with: .automatic)
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
            cell.cellBackgroundView.cornerRadius = 4
            cell.titleLabel.text = "Credit/Debit Card"
            
            cell.isChecked = self.selectedPaymentType == .card
            let imageForButton = cell.isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
            cell.leftButton.setImage(imageForButton, for: .normal)
            
            cell.leftButtonTapped = {
                cell.isChecked.toggle()
                self.selectedPaymentType = cell.isChecked ? .card : .none
                self.tableview.reloadRows(at: [IndexPath(row: 1, section: indexPath.section), IndexPath(row: 0, section: 3)], with: .automatic)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Adjust as needed for your cell layout.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "processPaymentSegue",
               let paymentVC = segue.destination as? ProcessPaymentViewController {
                paymentVC.totalPrice = totalPrice
                paymentVC.products = products
                paymentVC.selectedAddress = selectedAddress
            }
        }
}
