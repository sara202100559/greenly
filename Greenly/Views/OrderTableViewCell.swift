//
//  OrderTableViewCell.swift
//  Greenly
//
//  Created by Sumaya Janahi on 22/12/2024.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderID: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var orderOwner: UILabel!
    
    @IBOutlet weak var orderPrice: UILabel!
    
    @IBOutlet weak var orderStatus: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with order: Order) {
        orderID.text = "Order ID: \(order.id)"
        orderStatus.text = "Status: \(order.status.rawValue)"
        orderDate.text = order.date
        orderOwner.text = order.ownerName
        orderPrice.text = "\(order.price) BD"
       }
    
}
