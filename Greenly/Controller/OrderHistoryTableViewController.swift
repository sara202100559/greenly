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
        orders = UserDefaults.standard.loadOrders()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OrderCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        let order = orders[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
        \(order.storeName) - \(order.price) - \(order.status)
        Date: \(order.date)
        Order ID: \(order.orderID)
        """
        return cell
    }
}
