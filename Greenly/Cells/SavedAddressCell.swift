//
//  SavedAddressCell.swift
//  MyProject
//
//  Created by BP-36-201-01 on 15/12/2024.
//

import UIKit
class SavedAddressCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var AddNameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var roadLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var cellAddress = [String: String]()
    
    var isChecked = true {
        didSet {
            updateCheckboxAppearance() // Update checkbox appearance.
        }
    }
    var onCheckboxToggle: ((Bool) -> Void)? // Closure to notify checkbox state changes.
    var onDelete: (() -> Void)? // Closure to notify deletion of address.

    func updateCheckboxAppearance() {
        let image = isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        checkBoxButton.setImage(image, for: .normal)
    }
    
    @IBAction func checkboxButtonTapped(_ sender: UIButton) { // NEW: Action for checkbox button
        isChecked.toggle() // Toggle the checkbox state
        onCheckboxToggle?(isChecked) // Notify the parent view controller
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        onDelete?()
    }
    
}
