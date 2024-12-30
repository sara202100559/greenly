import UIKit

class ProcessPaymentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var paymentDetails: [String] = ["", "", ""] // Card Number, Expiration Date, CVV
    var validationStatus: [Bool] = [false, false, false] // Validation status for each field

    // Additional properties to hold order data
    var totalPrice: Double = 0.0
    var products: [CartProduct]?
    var selectedAddress: [String: String]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "InputTableViewCell", bundle: .main), forCellReuseIdentifier: "InputTableViewCell")
        tableView.register(UINib(nibName: "CheckoutCell", bundle: .main), forCellReuseIdentifier: "CheckoutCell")
    }
    
    func processPayment(completion: @escaping () -> Void) {
        let successAlert = UIAlertController(
            title: "Payment Successful!",
            message: "Thank you for your payment.",
            preferredStyle: .alert
        )
        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Invoke the completion handler after the alert is dismissed
            completion()
        }))
        
        self.present(successAlert, animated: true, completion: nil)
    }
    
    func processOrder() {
        guard let selectedProducts = products, let selectedAddress = selectedAddress else { return }

        // Generate order details
        let orderId = generateOrderID()
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateTime = formatter.string(from: currentDate)

        // Prepare order items
        let orderItems = selectedProducts.map { product in
            return OrderItem(
                name: product.name!,
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
            storeName: selectedAddress["name"] ?? "N/A",
            items: orderItems,
            paymentMethod: "card" // Assuming card payment
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
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }

    
    private func generateOrderID() -> String {
        let orderCountKey = "orderCountKey"
        let currentCount = UserDefaults.standard.integer(forKey: orderCountKey) // Default is 0
        let newCount = currentCount + 1
        UserDefaults.standard.set(newCount, forKey: orderCountKey)
        return String(newCount)
    }
}

extension ProcessPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as! InputTableViewCell
            cell.inputTextField.tag = indexPath.row
            switch indexPath.row {
            case 0:
                cell.inputTextField.placeholder = "Card Number (16 digits)"
                cell.inputTextField.keyboardType = .numberPad
            case 1:
                cell.inputTextField.placeholder = "Expiration Date (MM-YY)"
                cell.inputTextField.keyboardType = .numbersAndPunctuation
            case 2:
                cell.inputTextField.placeholder = "CVV (3 digits)"
                cell.inputTextField.keyboardType = .numberPad
            default:
                break
            }
            cell.inputTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell
            cell.CheckoutButton.layer.cornerRadius = 10
            cell.CheckoutButton.layer.borderWidth = 1
            cell.CheckoutButton.setTitle("Pay Now", for: .normal)
            
            // Enable the button only if all fields are valid
            cell.CheckoutButton.isEnabled = validationStatus.allSatisfy { $0 }
            
            cell.checkOutButtonTapped = { [weak self] in
                guard let self = self else { return }

                if self.validationStatus.allSatisfy({ $0 }) {
                    self.processPayment(completion: {
                        self.processOrder() // Save order data after payment
                    })
                }
            }
            return cell
        }
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let index = sender.tag
        
        switch index {
        case 0:
            validationStatus[index] = text.count == 16 && text.allSatisfy { $0.isNumber }
        case 1:
            let components = text.split(separator: "-")
            if components.count == 2,
               components[0].count == 2, components[1].count == 2,
               let month = Int(components[0]), let year = Int(components[1]),
               month >= 1 && month <= 12 && year > 24 {
                validationStatus[index] = true
            } else {
                validationStatus[index] = false
            }
        case 2:
            validationStatus[index] = text.count == 3 && text.allSatisfy { $0.isNumber }
        default:
            break
        }
        
        if index < paymentDetails.count {
            paymentDetails[index] = text
        }
        
        let checkoutIndexPath = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [checkoutIndexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.00001 : 11
    }
}
