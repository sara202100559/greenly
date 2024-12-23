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

        // Load the image from the logoUrl
        if let url = URL(string: store.logoUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.photo.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.photo.image = UIImage(named: "storefront") // Use a default placeholder image
                    }
                }
            }
        } else {
            photo.image = UIImage(named: "storefront") // Use a default placeholder image if URL is invalid
        }
    }
}
