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
        // Add header view with "My Order" label
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            headerView.backgroundColor = .clear
            
            let titleLabel = UILabel()
            titleLabel.text = "My Order"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            titleLabel.textColor = .black
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addSubview(titleLabel)
            
            // Add constraints for left alignment
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16), // 16 points padding from the left
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            tableView.tableHeaderView = headerView
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
        cell.storeNameLabel.text = order.storeName
        cell.priceLabel.text = "\(order.price) BD"
        cell.dateLabel.text = "Date: \(order.date)"
        cell.orderIDLabel.text = "Order ID: \(order.orderID)"
        cell.statusLabel.text = order.status
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 120 // Adjust height to allow for padding and spacing
      }

      override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          return UIView() // Removes extra separators
      }

      override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 0 // No footer spacing
      }
}

