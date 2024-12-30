//
//  FeedbackCell.swift
//  Greenly
//
//  Created by ahmedkamal on 30/12/2024.
//

import UIKit

protocol FeedbackCellDelegate: AnyObject {
    func didPressDeleteButton(on cell: FeedbackCell)
}
class FeedbackCell: UITableViewCell {
    
    weak var delegate: FeedbackCellDelegate?

    @IBOutlet weak var feedback: UILabel!
    @IBOutlet weak var starOne: UIButton!
    @IBOutlet weak var starTwo: UIButton!
    @IBOutlet weak var starThree: UIButton!
    @IBOutlet weak var starFour: UIButton!
    @IBOutlet weak var starFive: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateStarButtons(rating: 0) // Initially set to no rating
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

    }
    
    @objc func deleteButtonTapped() {
            // Notify the delegate when the delete button is pressed
            delegate?.didPressDeleteButton(on: self)
        }
    
    func configure(with order: Order) {
        feedback.text = order.feedback
//          ratingLabel.text = "Rating: \(order.rating ?? 0)"
      }
    
    private func updateStarButtons(rating: Int) {
          // Update the star buttons based on the rating value
          starOne.setImage(UIImage(systemName: rating >= 1 ? "star.fill" : "star"), for: .normal)
          starTwo.setImage(UIImage(systemName: rating >= 2 ? "star.fill" : "star"), for: .normal)
          starThree.setImage(UIImage(systemName: rating >= 3 ? "star.fill" : "star"), for: .normal)
          starFour.setImage(UIImage(systemName: rating >= 4 ? "star.fill" : "star"), for: .normal)
          starFive.setImage(UIImage(systemName: rating >= 5 ? "star.fill" : "star"), for: .normal)
      }
    

    
}
