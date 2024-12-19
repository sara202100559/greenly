//
//  CheckoutTableViewCell.swift
//  MyProject
//
//  Created on 13/12/24.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    
    var isChecked: Bool = false {
        didSet {
            updateCheckboxAppearance() // Update checkbox appearance.
        }
    }

    var leftButtonTapped: (() -> Void)?
    
    override class func awakeFromNib() {
        
    }

    func updateCheckboxAppearance() {
        let image = isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        leftButton.setImage(image, for: .normal)
    }

    @IBAction func leftButtonAction(_ sender: Any) {
        leftButtonTapped?()
    }
}
