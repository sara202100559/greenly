//
//  FeedbackViewController.swift
//  Greenly
//
//  Created by Sumaya Janahi on 23/12/2024.
//

import UIKit

protocol FeedbackDelegate: AnyObject {
    func didSubmitFeedback(for order: Order)
    func didDeleteFeedback(for order: Order)
}

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var starOne: UIButton!
    @IBOutlet weak var starTwo: UIButton!
    @IBOutlet weak var starThree: UIButton!
    @IBOutlet weak var starFour: UIButton!
    @IBOutlet weak var starFive: UIButton!
    
    var order: Order?
    weak var delegate: FeedbackDelegate?
    var isStoreOwnerView: Bool = false // New property
    
    var selectedRating: Int = 0 {
        didSet {
            updateStarButtons()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTextView.delegate = self

        // Set up the initial state of the feedback UI
        feedbackTextView.text = "Add feedback here..."
        feedbackTextView.textColor = .lightGray
        
        // Set the default star rating to 0 (no rating)
        selectedRating = 0
        
        // If feedback is already provided for the order, show it
        if let existingFeedback = order?.feedback, let existingRating = order?.rating {
            feedbackTextView.text = existingFeedback
            feedbackTextView.textColor = .black
            selectedRating = existingRating
        }
        
        // Configure the view for store owner
        if isStoreOwnerView {
            submitBtnOutlet.setTitle("OK", for: .normal) // Change button title to "OK"
            feedbackTextView.isEditable = false         // Make feedback text non-editable
            disableStarButtons()                        // Disable star button interactions
        }
        
        // Show the delete button if feedback exists
        deleteButton.isHidden = order?.feedback == nil
    }
    
    func disableStarButtons() {
        // Disable all star buttons
        starOne.isEnabled = false
        starTwo.isEnabled = false
        starThree.isEnabled = false
        starFour.isEnabled = false
        starFive.isEnabled = false
    }

    @IBAction func starBtnPressed(_ sender: UIButton) {
        if !isStoreOwnerView { // Only allow star selection for customers
            selectedRating = sender.tag
        }
    }
    
    @IBAction func deleteFeedBack(_ sender: UIButton) {
        // Remove the feedback and reset the rating
        order?.feedback = nil
        order?.rating = 0
        
        // Notify the delegate that feedback has been deleted
        if let updatedOrder = order {
            delegate?.didDeleteFeedback(for: updatedOrder)
        }
        
        // Reset the UI
        feedbackTextView.text = "Add feedback here..."
        feedbackTextView.textColor = .lightGray
        selectedRating = 0
        
        // Hide the delete button since there's no feedback to delete now
        deleteButton.isHidden = true
        
        // Dismiss the view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitFeedBack(_ sender: UIButton) {
        if isStoreOwnerView {
            // For store owner, just dismiss the view when "OK" is pressed
            self.dismiss(animated: true, completion: nil)
        } else {
            guard let feedback = feedbackTextView.text, !feedback.isEmpty, feedbackTextView.textColor != .lightGray else {
                // Show an error if feedback is empty
                AlertHelper.showAlert(on: self, title: "Error", message: "Please enter feedback before submitting.")
                return
            }
                   
            // Save the feedback and rating to the order
            order?.feedback = feedback
            order?.rating = selectedRating
            
            // Save the order back to UserDefaults
            var orders = UserDefaults.standard.loadOrders()
            if let index = orders.firstIndex(where: { $0.id == order?.id }) {
                orders[index] = order!
                UserDefaults.standard.saveOrders(orders)
            }
                   
            // Notify the delegate that feedback has been submitted
            if let updatedOrder = order {
                delegate?.didSubmitFeedback(for: updatedOrder)
            }
            
            showSuccessAlert()
        }
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Thank you for your feedback!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Dismiss the feedback view controller when "OK" is pressed
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
  
    func updateStarButtons() {
        // Update the star buttons' images based on the selected rating
        starOne.setImage(UIImage(systemName: selectedRating >= 1 ? "star.fill" : "star"), for: .normal)
        starTwo.setImage(UIImage(systemName: selectedRating >= 2 ? "star.fill" : "star"), for: .normal)
        starThree.setImage(UIImage(systemName: selectedRating >= 3 ? "star.fill" : "star"), for: .normal)
        starFour.setImage(UIImage(systemName: selectedRating >= 4 ? "star.fill" : "star"), for: .normal)
        starFive.setImage(UIImage(systemName: selectedRating >= 5 ? "star.fill" : "star"), for: .normal)
        
        // Optional: Set the color for the stars
        let starColor = UIColor.init(hex: "728F41")
        starOne.tintColor = starColor
        starTwo.tintColor = starColor
        starThree.tintColor = starColor
        starFour.tintColor = starColor
        starFive.tintColor = starColor
    }
    
    // UITextViewDelegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add feedback here..." && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add feedback here..."
            textView.textColor = .lightGray
        }
    }
}



////
////  FeedbackViewController.swift
////  Greenly
////
////  Created by Sumaya Janahi on 23/12/2024.
////
//
//import UIKit
//
//protocol FeedbackDelegate: AnyObject {
//    func didSubmitFeedback(for order: Order)
//    func didDeleteFeedback(for order: Order)
//}
//
//class FeedbackViewController: UIViewController, UITextViewDelegate {
//    
//    
//    @IBOutlet weak var feedbackTextView: UITextView!
//    @IBOutlet weak var submitBtnOutlet: UIButton!
//    @IBOutlet weak var deleteButton: UIButton!
//    
//    @IBOutlet weak var starOne: UIButton!
//    @IBOutlet weak var starTwo: UIButton!
//    @IBOutlet weak var starThree: UIButton!
//    @IBOutlet weak var starFour: UIButton!
//    @IBOutlet weak var starFive: UIButton!
//    
//    var order: Order?
//    weak var delegate: FeedbackDelegate?
//    
//    var selectedRating: Int = 0 {
//           didSet {
//               updateStarButtons()
//           }
//       }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        feedbackTextView.delegate = self
//
//        // Set up the initial state of the feedback UI
//        feedbackTextView.text = "Enter your feedback here..."
//        feedbackTextView.textColor = .lightGray
//        
//        // Set the default star rating to 0 (no rating)
//        selectedRating = 0
//        
//        // If feedback is already provided for the order, show it
//        if let existingFeedback = order?.feedback, let existingRating = order?.rating {
//            feedbackTextView.text = existingFeedback
//            selectedRating = existingRating
//        }
//        
//        // Show the delete button if feedback exists
//        deleteButton.isHidden = order?.feedback == nil
//
//    }
//    
//    @IBAction func starBtnPressed(_ sender: UIButton) {
//      selectedRating = sender.tag
//    }
//    
//    @IBAction func deleteFeedBack(_ sender: UIButton) {
//        // Remove the feedback and reset the rating
//                order?.feedback = nil
//                order?.rating = 0
//                
//                // Notify the delegate that feedback has been deleted
//                if let updatedOrder = order {
//                    delegate?.didDeleteFeedback(for: updatedOrder)
//                }
//                
//                // Reset the UI
//                feedbackTextView.text = "Enter your feedback here..."
//                feedbackTextView.textColor = .lightGray
//                selectedRating = 0
//                
//                // Hide the delete button since there's no feedback to delete now
//                deleteButton.isHidden = true
//                
//                // Pop the view controller (dismiss the pop-up)
//        self.dismiss(animated: true)
//    }
//    
//    @IBAction func submitFeedBack(_ sender: UIButton) {
//        guard let feedback = feedbackTextView.text, !feedback.isEmpty else {
//                   // Show an error if feedback is empty
//                   AlertHelper.showAlert(on: self, title: "Error", message: "Please enter feedback before submitting.")
//                   return
//               }
//               
//               // Save the feedback and rating to the order
//               order?.feedback = feedback
//               order?.rating = selectedRating
//        
//        // Save the order back to UserDefaults
//        var orders = UserDefaults.standard.loadOrders()
//        if let index = orders.firstIndex(where: { $0.id == order?.id }) {
//            orders[index] = order!
//            UserDefaults.standard.saveOrders(orders)
//        }
//               // Notify the delegate that feedback has been submitted
//               if let updatedOrder = order {
//                   delegate?.didSubmitFeedback(for: updatedOrder)
//               }
//        showSuccessAlert()
//               // Pop the view controller (dismiss the pop-up)
////        self.dismiss(animated: true)
//    }
//    
//    func showSuccessAlert() {
//        let alert = UIAlertController(title: "Success", message: "Thank you for your feedback!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            // Dismiss the feedback view controller when "OK" is pressed
//            self.dismiss(animated: true, completion: nil)
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//  
//    func updateStarButtons() {
//        // Update the star buttons' images based on the selected rating
//        starOne.setImage(UIImage(systemName: selectedRating >= 1 ? "star.fill" : "star"), for: .normal)
//        starTwo.setImage(UIImage(systemName: selectedRating >= 2 ? "star.fill" : "star"), for: .normal)
//        starThree.setImage(UIImage(systemName: selectedRating >= 3 ? "star.fill" : "star"), for: .normal)
//        starFour.setImage(UIImage(systemName: selectedRating >= 4 ? "star.fill" : "star"), for: .normal)
//        starFive.setImage(UIImage(systemName: selectedRating >= 5 ? "star.fill" : "star"), for: .normal)
//        
//        // Optional: Set the color for the stars
//        let starColor = UIColor.init(hex: "728F41")
//        starOne.tintColor = starColor
//        starTwo.tintColor = starColor
//        starThree.tintColor = starColor
//        starFour.tintColor = starColor
//        starFive.tintColor = starColor
//    }
//    
//}
