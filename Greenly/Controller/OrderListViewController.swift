//
//  OrderListViewController.swift
//  Greenly
//
//  Created by Sumaya Janahi on 22/12/2024.
//

import UIKit

class OrderListViewController: UIViewController, OrderDetailsDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var orders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
           tableView.dataSource = self
        
        let nib = UINib(nibName: "OrderTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "OrderTableViewCell")
        title = "Manage Orders"

        loadOrders() // Load orders from UserDefaults
    }
    
    func loadOrders() {
        orders = UserDefaults.standard.loadOrders()
        tableView.reloadData()
    }
//    func loadDummyData() {
//        orders = [
//            Order(id: "1", status: .pending, date: "2024-12-01", price: 29.99, ownerName: "Sumaya Janahi", feedback: nil, rating: nil, storeName: "Green Shop", items: [OrderItem(name: "Organic Apples", price: "4.99", quantity: "2"), OrderItem(name: "Almond Milk", price: "3.99", quantity: "1")], paymentMethod: "Credit Card"),
//            Order(id: "2", status: .delivering, date: "2024-12-02", price: 49.99, ownerName: "Sara Alhashimi", feedback: nil, rating: nil, storeName: "Nature's Basket", items: [OrderItem(name: "Fresh Bananas", price: "1.99", quantity: "5"), OrderItem(name: "Organic Honey", price: "9.99", quantity: "1")], paymentMethod: "Cash on Delivery"),
//            Order(id: "3", status: .delivered, date: "2024-11-30", price: 19.99, ownerName: "Fatima Albuarki", feedback: "Great quality products!", rating: 5, storeName: "Eco Market", items: [OrderItem(name: "Chia Seeds", price: "5.99", quantity: "1"), OrderItem(name: "Avocados", price: "2.99", quantity: "3")], paymentMethod: "Credit Card"),
//            Order(id: "4", status: .pending, date: "2024-12-03", price: 39.99, ownerName: "Maryam Alsaffar", feedback: nil, rating: nil, storeName: "Healthy Harvest", items: [OrderItem(name: "Quinoa", price: "6.99", quantity: "1"), OrderItem(name: "Fresh Oranges", price: "4.99", quantity: "4")], paymentMethod: "PayPal"),
//            Order(id: "5", status: .delivering, date: "2024-12-04", price: 59.99, ownerName: "Qamreen Hasan", feedback: nil, rating: nil, storeName: "Natural Foods", items: [OrderItem(name: "Spinach", price: "3.99", quantity: "2"), OrderItem(name: "Almond Butter", price: "7.99", quantity: "1")], paymentMethod: "Cash on Delivery")
//        ]
//        tableView.reloadData()
//    }

    
//    func loadDummyData() {
//        orders = [
//            Order(id: "1", status: .pending, date: "2024-12-01", price: 29.99, ownerName: "Sumaya Janahi"),
//            Order(id: "2", status: .delivering, date: "2024-12-02", price: 49.99, ownerName: "Sara Alhashimi"),
//            Order(id: "3", status: .delivered, date: "2024-11-30", price: 19.99, ownerName: "Fatima Albuarki"),
//            Order(id: "4", status: .pending, date: "2024-12-03", price: 39.99, ownerName: "Maryam Alsaffar"),
//            Order(id: "5", status: .delivering, date: "2024-12-04", price: 59.99, ownerName: "Qamreen Hasan")
//        ]
//        tableView.reloadData() // Refresh the table view with new data
//    }
    
    // Delegate method implementation
    func didUpdateOrder(_ order: Order) {
        // Find the index of the updated order
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            orders[index] = order
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
             let order = orders[indexPath.row]
             cell.configure(with: order) // Call the configure function
             return cell
    }

    // Set the height of the table view cells
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 130 // Set a static height, you can change this value as needed
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOrder = orders[indexPath.row]
        let vc = UIStoryboard(name: "StoreOwner", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.order = selectedOrder
        vc.delegate = self // Set the delegate to the current view controller
        navigationController?.pushViewController(vc, animated: true)

            }

}
