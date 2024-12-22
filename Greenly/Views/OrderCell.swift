//
//  OrderCell.swift
//  Greenly
//
//  Created by Sumaya janahi on 21/12/2024.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView! // Background view
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

//        // Ensure the containerView is connected before applying styles
//        guard let containerView = containerView else {
//            print("containerView is not connected!")
//            return
//        }

        // Add rounded corners and shadow
        //containerView.layer.cornerRadius = 8
        //containerView.layer.masksToBounds = false
        //containerView.layer.shadowColor = UIColor.black.cgColor
       // containerView.layer.shadowOpacity = 0.1
       // containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        //containerView.layer.shadowRadius = 5
    }
}




