//
//  OrderDetailsVC.swift
//  Greenly
//
//  Created by Sumaya Janahi on 22/12/2024.
//

import UIKit

protocol OrderDetailsDelegate: AnyObject {
    func didUpdateOrder(_ order: Order)
}

class OrderDetailsVC: UIViewController {

    
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeStatusButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    
    var order: Order?
    weak var delegate: OrderDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        feedbackButton.isHidden = order?.status != .delivered
    }
    
    @IBAction func feedBackBtnPressed(_ sender: UIButton) {
        guard let order = order else { return }
            
        let feedbackVC = UIStoryboard(name: "StoreOwner", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
               feedbackVC.order = order
               feedbackVC.delegate = self // Set the delegate
               
               // Present the feedback view controller modally (as a pop-up)
               feedbackVC.modalPresentationStyle = .overCurrentContext
               feedbackVC.modalTransitionStyle = .crossDissolve
               present(feedbackVC, animated: true, completion: nil)
    }
    
    @IBAction func changeStatusButtonTapped(_ sender: UIButton) {
        guard let order = order else { return }
        
        if order.status == .delivering {
            self.order?.status = .delivered
        } else {
            self.order?.status = .delivering
        }
        
        updateUI()
        
        if let updatedOrder = self.order {
            delegate?.didUpdateOrder(updatedOrder)
            
            var orders = UserDefaults.standard.loadOrders()
            if let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) {
                orders[index] = updatedOrder
                UserDefaults.standard.saveOrders(orders)
            }
        }
        
        feedbackButton.isHidden = self.order?.status != .delivered
    }
    
    private func updateUI() {
        guard let order = order else { return }
        orderIDLabel.text = "Order ID: \(order.id)"
        orderStatusLabel.text = "Status: \(order.status.rawValue)"
        dateLabel.text = "Date: \(order.date)"
        priceLabel.text = "Price: \(String(format: "%.2f", order.price)) BD"
        nameLabel.text = "Owner: \(order.ownerName)"
        changeStatusButton.setTitle(order.status == .delivering ? "Mark as Delivered" : "Mark as Delivering", for: .normal)
    }
}

// Extension for handling feedback submission and deletion
extension OrderDetailsVC: FeedbackDelegate {
    func didSubmitFeedback(for order: Order) {
        // Update the order with feedback and rating
        self.order = order
        // You can also notify any other screen if needed
        print("Feedback submitted: \(order.feedback ?? "No feedback")")
    }
    
    func didDeleteFeedback(for order: Order) {
        // Remove the feedback from the order
        self.order?.feedback = nil
        self.order?.rating = 0
        // Update the UI to reflect the change
        updateUI()
    }
}
