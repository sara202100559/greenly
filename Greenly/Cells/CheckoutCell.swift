//
//  CheckoutCell.swift
//  MyProject
//
//  Created by BP-36-201-01 on 11/12/2024.
//

import UIKit

class CheckoutCell: UITableViewCell {

    @IBOutlet weak var CheckoutButton: UIButton!
    
    var checkOutButtonTapped: (() -> Void)?
    
    @IBAction func checkoutButtonAction(_ sender: Any) {
        checkOutButtonTapped?()
    }

}
