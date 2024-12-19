//
//  AddCartCell.swift
//  MyProject
//
//  Created by BP-36-201-07 on 10/12/2024.
//

import UIKit

protocol AddCartCellDelegate: AnyObject {
    func addToCartButtonTapped()
}

class AddCartCell: UITableViewCell {

    @IBOutlet weak var AddToCart: UIButton!
    
    weak var buttonDelegate: AddCartCellDelegate?
    
    @IBAction func addToCartButtonAction(_ sender: Any) {
        self.buttonDelegate?.addToCartButtonTapped()
    }
}
