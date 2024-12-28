//
//  OrderHistoryTableViewController.swift
//  Greenly
//
//  Created by BP-36-201-02 on 19/12/2024.
//

//import UIKit
//
//class OrderHistoryTableViewController: UITableViewController {
//
//    var orders: [Order] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadOrders()
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 100 //Set an estimated height
//        self.title = "My Order"
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadOrders()
//    }
//
//    private func loadOrders() {
//        orders = UserDefaults.standard.loadOrders()
//        if orders.isEmpty {
//            showEmptyPlaceholder()
//        } else {
//            hideEmptyPlaceholder()
//        }
//        tableView.reloadData()
//    }
//
//    private func showEmptyPlaceholder() {
//        let placeholderLabel = UILabel()
//        placeholderLabel.text = "No orders yet."
//        placeholderLabel.textColor = .gray
//        placeholderLabel.textAlignment = .center
//        placeholderLabel.font = UIFont.systemFont(ofSize: 30)
//        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundView = placeholderLabel
//        tableView.separatorStyle = .none
//    }
//
//    private func hideEmptyPlaceholder() {
//        tableView.backgroundView = nil
//        tableView.separatorStyle = .singleLine
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return orders.count }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell else {
//            fatalError("Failed to dequeue OrderCell")
//        }
//        let order = orders[indexPath.row]
//        cell.storeNameLabel.text = order.storeName
//        cell.priceLabel.text = "\(order.price) BD"
//        cell.dateLabel.text = "Date: \(order.date)"
//        cell.orderIDLabel.text = "Order ID: \(order.id)"
//        cell.statusLabel.text = order.status.rawValue
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let selectedOrder = orders[indexPath.row] // Get the selected order
//
//        // Perform the segue and pass the order
//        performSegue(withIdentifier: "showOrderStatus", sender: selectedOrder)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showOrderStatus",
//           let destinationVC = segue.destination as? OrderStatusViewController,
//           let selectedOrder = sender as? Order {
//            destinationVC.order = selectedOrder // Pass the selected order
//        }
//    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            let headerView = UIView()
//            let titleLabel = UILabel()
//            titleLabel.text = "My Orders"
//            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
//            titleLabel.translatesAutoresizingMaskIntoConstraints = false
//            headerView.addSubview(titleLabel)
//
//            NSLayoutConstraint.activate([
//                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
//            ])
//
//            return headerView
//        }
//        return nil
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 50 : 0
//    }
//}
//
//
//// MARK: - OrderDetailsDelegate
//extension OrderHistoryTableViewController: OrderDetailsDelegate {
//    func didUpdateOrder(_ order: Order) {
//        if let index = orders.firstIndex(where: { $0.id == order.id }) {
//            orders[index] = order
//            UserDefaults.standard.saveOrders(orders)
//            tableView.reloadData()
//        }
//    }
//}


import UIKit

class OrderHistoryTableViewController: UITableViewController {
    
    var orders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOrders()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        self.title = "My Orders"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrders()
    }
    
    private func loadOrders() {
        orders = UserDefaults.standard.loadOrders()
        if orders.isEmpty {
            showEmptyPlaceholder()
        } else {
            hideEmptyPlaceholder()
        }
        tableView.reloadData()
    }
    
    private func showEmptyPlaceholder() {
        let placeholderLabel = UILabel()
       // placeholderLabel.text = "No orders yet."
        placeholderLabel.textColor = .gray
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = UIFont.systemFont(ofSize: 30)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundView = placeholderLabel
        tableView.separatorStyle = .none
    }
    
    private func hideEmptyPlaceholder() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return orders.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell else {
            fatalError("Failed to dequeue OrderCell")
        }
        let order = orders[indexPath.row]
        cell.storeNameLabel.text = order.storeName
        cell.priceLabel.text = "\(order.price) BD"
        cell.dateLabel.text = "Date: \(order.date)"
        cell.orderIDLabel.text = "Order ID: \(order.id)"
        cell.statusLabel.text = order.status.rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOrder = orders[indexPath.row]
        performSegue(withIdentifier: "showOrderStatus", sender: selectedOrder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOrderStatus",
           let destinationVC = segue.destination as? OrderStatusViewController,
           let selectedOrder = sender as? Order {
            destinationVC.order = selectedOrder
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView()
            let titleLabel = UILabel()
            titleLabel.text = "My Orders"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            return headerView
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 0
    }
}
