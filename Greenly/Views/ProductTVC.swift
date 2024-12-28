//
//  ProductTVC.swift
//  Greenly
//
//  Created by Sumaya Janahi on 22/12/2024.
//

import UIKit

class ProductTVC: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var prodcutImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with product: Product) {
        productName.text = product.name
        // Set the image if imageData is available
        //        if let imageData = product.imageData {
        //            prodcutImgView.image = UIImage(data: imageData)
        //             } else {
        //                 prodcutImgView.image = nil // or set a placeholder image
        //             }
        //         }
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


