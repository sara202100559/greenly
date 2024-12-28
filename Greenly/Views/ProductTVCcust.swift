//
//  ProductTVCcust.swift
//  Greenly
//
//  Created by Sumaya janahi on 27/12/2024.
//

import UIKit

class ProductTVCcust: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var prodcutImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with product: Product) {
        productName.text = product.name
        productPrice.text = product.price
        if let imageUrlString = product.imageUrl, // Ensure the string is not nil
           let url = URL(string: imageUrlString) { // Convert the string to a URL
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: url), // Download the image data
                   let image = UIImage(data: imageData) { // Convert data to UIImage
                    DispatchQueue.main.async {
                        self.prodcutImgView.image = image // Set the image in the UIImageView
                    }
                } else {
                    DispatchQueue.main.async {
                        self.prodcutImgView.image = UIImage(named: "placeholder_image") // Set a placeholder if loading fails
                    }
                }
            }
        } else {
            self.prodcutImgView.image = UIImage(named: "placeholder_image") // Set a placeholder if the URL is invalid
        }
    }
    
}
