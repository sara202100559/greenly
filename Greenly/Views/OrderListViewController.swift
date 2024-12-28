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
            // Load dummy data
           // loadDummyData()
    }
    
//    func loadDummyData() {
//        orders = [
//            Order(id: "001", status: .pending, date: "2024-12-01", price: 29.99, ownerName: "Alice Johnson"),
//            Order(id: "002", status: .delivering, date: "2024-12-02", price: 49.99, ownerName: "Bob Smith"),
//            Order(id: "003", status: .delivered, date: "2024-11-30", price: 19.99, ownerName: "Charlie Brown"),
//            Order(id: "004", status: .pending, date: "2024-12-03", price: 39.99, ownerName: "Diana Prince"),
//            Order(id: "005", status: .delivering, date: "2024-12-04", price: 59.99, ownerName: "Evan Lee")
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
