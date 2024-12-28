//
//  ItemCell.swift
//  MyProject
//
//  Created by BP-36-201-01 on 11/12/2024.
//

import UIKit

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    var quantity: Int = 0 {
        didSet {
            quantityLabel.text = "\(quantity)" // Update quantity label.
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            updateCheckboxAppearance() // Update checkbox appearance.
        }
    }
    
    var onQuantityChange: ((Int) -> Void)? // Closure to notify quantity changes.
    var onCheckboxToggle: ((Bool) -> Void)? // Closure to notify checkbox state changes.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI() // Initialize UI components.
    }
    
    func setupUI() {
        quantityLabel.text = "\(quantity)" // Set initial quantity.
        updateCheckboxAppearance() // Set initial checkbox state.
        plusButton.borderWidth = 1
        minusButton.borderWidth = 1
        quantityLabel.borderWidth = 1
        plusButton.layer.borderColor = UIColor(red: 217, green: 217, blue: 217, alpha: 1).cgColor
        minusButton.layer.borderColor = UIColor(red: 217, green: 217, blue: 217, alpha: 1).cgColor
        quantityLabel.layer.borderColor = UIColor(red: 217, green: 217, blue: 217, alpha: 1).cgColor
    }
    
    func updateCheckboxAppearance() {
        let image = isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        checkboxButton.setImage(image, for: .normal)
    }
    
    @IBAction func checkboxButtonTapped(_ sender: UIButton) { // NEW: Action for checkbox button
        isChecked.toggle() // Toggle the checkbox state
        onCheckboxToggle?(isChecked) // Notify the parent view controller
    }
    
    
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        if quantity > 0 {
            quantity -= 1
            onQuantityChange?(quantity)
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        quantity += 1
        onQuantityChange?(quantity)
    }
}
