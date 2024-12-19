//
//  SubCell.swift
//  MyProject
//
//  Created by BP-36-201-01 on 11/12/2024.
//

import UIKit

class SubCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var cellBackgroundViewLeadingConstraint: NSLayoutConstraint! // 12
    @IBOutlet weak var cellBackgroundViewTrailingConstraint: NSLayoutConstraint! // 12
    
    var isChecked = true {
        didSet {
            updateCheckboxAppearance() // Update checkbox appearance.
        }
    }
    var onCheckboxToggle: ((Bool) -> Void)? // Closure to notify checkbox state changes.

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUI() {
        cellBackgroundView.cornerRadius = 4
    }

    func updateCheckboxAppearance() {
        let image = isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        checkButton.setImage(image, for: .normal)
    }
    
    @IBAction func checkboxButtonTapped(_ sender: UIButton) { // NEW: Action for checkbox button
        isChecked.toggle() // Toggle the checkbox state
        onCheckboxToggle?(isChecked) // Notify the parent view controller
    }

}
