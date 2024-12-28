//
//  TrackerCell.swift
//  testing
//
//  Created by BP-36-201-01 on 21/12/2024.
//

import UIKit

class TrackerCell: UITableViewCell {

    
    @IBOutlet weak var circle1: UIImageView!
    
    @IBOutlet weak var circle2: UIImageView!
    
    @IBOutlet weak var circle3: UIImageView!
    
    
    @IBOutlet weak var Pending: UILabel!
    
    @IBOutlet weak var Out: UILabel!
    
    @IBOutlet weak var Delivered: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
