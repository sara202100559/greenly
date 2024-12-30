//
//  FeedbackListVC.swift
//  Greenly
//
//  Created by ahmedkamal on 30/12/2024.
//

import UIKit

class FeedbackListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var order: Order?

    var ordersWithFeedback: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Customer Feedback"
            tableView.delegate = self
            tableView.dataSource = self
        let nib = UINib(nibName: "FeedbackCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "FeedbackCell")
        loadOrdersWithFeedback()

            

    }
    private func loadOrdersWithFeedback() {
           // If we received an order, add it to the ordersWithFeedback array
           if let order = order, order.feedback != nil {
               ordersWithFeedback = [order]  // Only add this order with feedback
           } else {
               // Load all orders from UserDefaults and filter out those with no feedback
               let allOrders = UserDefaults.standard.loadOrders()
               ordersWithFeedback = allOrders.filter { $0.feedback != nil }
           }
           
           // Reload the table view to display the feedback data
           tableView.reloadData()
       }
    
    private func loadFeedbacks(for order: Order) {
//           // Assuming each order can have multiple feedbacks.
//           // This can be an array of tuples or a custom data structure for storing multiple feedbacks.
//
//           // For this example, we assume feedbacks are stored as an array of tuples with (feedback, rating).
//           if let feedback = order.feedback, let rating = order.rating {
//               feedbackList.append((feedback: feedback, rating: rating))
//           }
//
//           // If you have multiple feedbacks saved per order, you can add them similarly.
//           // For demo purposes, we assume there's one feedback per order. In a real-world case, this should be an array of feedbacks.
        // Load orders from UserDefaults
        let allOrders = UserDefaults.standard.loadOrders()
        
        // Filter orders with feedback
        ordersWithFeedback = allOrders.filter { $0.feedback != nil }
        tableView.reloadData()

       }
    
//    func deleteFeedback(for order: Order) {
//        // Remove the feedback from the order
//        if var updatedOrder = order {
//            updatedOrder.feedback = nil
//            updatedOrder.rating = 0
//
//            // Save the updated order to UserDefaults
//            var allOrders = UserDefaults.standard.loadOrders()
//            if let index = allOrders.firstIndex(where: { $0.id == updatedOrder.id }) {
//                allOrders[index] = updatedOrder
//                UserDefaults.standard.saveOrders(allOrders)
//            }
//
//            // Reload table view
//            loadOrdersWithFeedback()
//        }
//    }
//    private func deleteFeedback(at index: Int) {
//        // Delete the feedback from the list and update the order
//        feedbackList.remove(at: index)
//
//        // Update the order to reflect the deletion (this could be saving the change in your data source)
//        if var currentOrder = order {
//            // Remove the feedback from the order object
//            currentOrder.feedback = nil
//            currentOrder.rating = 0
//            // Here we assume you're saving the changes back to your data source
//            // You can update your data source or persist changes as needed
//        }
//
//        // Reload table view to reflect changes
//        tableView.reloadData()
//    }

}

extension FeedbackListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If feedback exists for the order, show one row, otherwise show no rows
        return ordersWithFeedback.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = ordersWithFeedback[indexPath.row]
             
             // Dequeue the FeedbackCell
             let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackCell
        cell.delegate = self
             // Configure the cell with order feedback data
        cell.configure(with: order)
             
             return cell
    }

    // Optionally, you can add more functionality here, like displaying ratings or other details
}

extension FeedbackListVC: FeedbackCellDelegate {

    func didPressDeleteButton(on cell: FeedbackCell) {
        // Find the index of the row the delete button was pressed in
        if let indexPath = tableView.indexPath(for: cell) {
            // Remove the feedback from the order
            var order = ordersWithFeedback[indexPath.row]
            order.feedback = nil
            order.rating = 0
            
            // Save the updated order to UserDefaults
            var allOrders = UserDefaults.standard.loadOrders()
            if let index = allOrders.firstIndex(where: { $0.id == order.id }) {
                allOrders[index] = order
                UserDefaults.standard.saveOrders(allOrders)
            }
            
            // Remove the order with feedback from the ordersWithFeedback array
            ordersWithFeedback.remove(at: indexPath.row)
            
            // Reload the table view to reflect the deletion
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
