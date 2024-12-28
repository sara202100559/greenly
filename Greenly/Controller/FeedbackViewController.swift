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

class FeedbackViewController: UIViewController {
    
    
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
    
    var selectedRating: Int = 0 {
           didSet {
               updateStarButtons()
           }
       }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the initial state of the feedback UI
        feedbackTextView.text = "Enter your feedback here..."
        feedbackTextView.textColor = .lightGray
        
        // Set the default star rating to 0 (no rating)
        selectedRating = 0
        
        // If feedback is already provided for the order, show it
        if let existingFeedback = order?.feedback, let existingRating = order?.rating {
            feedbackTextView.text = existingFeedback
            selectedRating = existingRating
        }
        
        // Show the delete button if feedback exists
        deleteButton.isHidden = order?.feedback == nil

    }
    
    @IBAction func starBtnPressed(_ sender: UIButton) {
      selectedRating = sender.tag
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
                feedbackTextView.text = "Enter your feedback here..."
                feedbackTextView.textColor = .lightGray
                selectedRating = 0
                
                // Hide the delete button since there's no feedback to delete now
                deleteButton.isHidden = true
                
                // Pop the view controller (dismiss the pop-up)
        self.dismiss(animated: true)
    }
    
    @IBAction func submitFeedBack(_ sender: UIButton) {
        guard let feedback = feedbackTextView.text, !feedback.isEmpty else {
                   // Show an error if feedback is empty
                   AlertHelper.showAlert(on: self, title: "Error", message: "Please enter feedback before submitting.")
                   return
               }
               
               // Save the feedback and rating to the order
               order?.feedback = feedback
               order?.rating = selectedRating
               
               // Notify the delegate that feedback has been submitted
               if let updatedOrder = order {
                   delegate?.didSubmitFeedback(for: updatedOrder)
               }
               
               // Pop the view controller (dismiss the pop-up)
        self.dismiss(animated: true)
    }
    
  
    func updateStarButtons() {
          // Update the star buttons' images based on the selected rating
        starOne.setImage(UIImage(named: selectedRating >= 1 ? "star.fill" : "star"), for: .normal)
        starTwo.setImage(UIImage(named: selectedRating >= 2 ? "star.fill" : "star"), for: .normal)
        starThree.setImage(UIImage(named: selectedRating >= 3 ? "star.fill" : "star"), for: .normal)
        starFour.setImage(UIImage(named: selectedRating >= 4 ? "star.fill" : "star"), for: .normal)
        starFive.setImage(UIImage(named: selectedRating >= 5 ? "star.fill" : "star"), for: .normal)
      }

}
