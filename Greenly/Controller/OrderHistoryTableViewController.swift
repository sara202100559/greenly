//
//  OrderHistoryTableViewController.swift
//  Greenly
//
//  Created by BP-36-201-02 on 19/12/2024.
//

import UIKit

class OrderHistoryTableViewController: UITableViewController {
    
    var orders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrders()
    }
    
    private func loadOrders() {
        orders = UserDefaults.standard.loadOrders()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell else {
            fatalError("Failed to dequeue OrderCell")
        }
        
        let order = orders[indexPath.row]
        cell.storeNameLabel.text = order.ownerName
        cell.priceLabel.text = "\(order.price) BD"
        cell.dateLabel.text = "Date: \(order.date)"
        cell.orderIDLabel.text = "Order ID: \(order.id)"
        cell.statusLabel.text = order.status.rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOrder = orders[indexPath.row]
        
        // Navigate to OrderDetailsVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let orderDetailsVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsVC {
            orderDetailsVC.order = selectedOrder
            orderDetailsVC.delegate = self
            navigationController?.pushViewController(orderDetailsVC, animated: true)
        }
    }
}

// MARK: - OrderDetailsDelegate
extension OrderHistoryTableViewController: OrderDetailsDelegate {
    func didUpdateOrder(_ order: Order) {
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            orders[index] = order
            UserDefaults.standard.saveOrders(orders)
            tableView.reloadData()
        }
    }
}
