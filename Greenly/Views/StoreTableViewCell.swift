//
//  StoreTableViewCell.swift
//  Greenly
//
//  Created by BP-36-201-01 on 08/12/2024.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // Update the cell's content with store details
    func update(with store: Details) {
        name.text = store.name
        if let imageData = store.imageData, let image = UIImage(data: imageData) {
            photo.image = image
        } else {
            photo.image = UIImage(named: "storefront") // Use a default placeholder image
        }
    }
}
