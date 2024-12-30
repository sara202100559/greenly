//
//  SuggestedProductCollectionCell.swift
//  Greenly
//

import UIKit

class SuggestedProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    func configure(with product: Product) {
        productNameLabel.text = product.name
        productPriceLabel.text = "$\(product.price)"
        if let urlString = product.imageUrl, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.productImageView.image = image
                    }
                }
            }
        }
    }
}
