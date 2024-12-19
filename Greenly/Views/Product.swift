//
//  Product.swift
//  Greenly
//
//  Created by BP-36-201-07 on 16/12/2024.
//

import Foundation
import UIKit

struct Product: Codable {
    var name: String
    var description: String
    var category: String
    var price: String
    var imageData: Data?
    var co2Emissions: String
    var plasticWaste: String
    var waterSaved: String
    var quantity: String
    
    init(name: String, description: String, category: String, price: String, image: UIImage, co2Emissions: String, plasticWaste: String, waterSaved: String, quantity: String) {
        self.name = name
        self.description = description
        self.category = category
        self.price = price
        self.imageData = image.pngData()
        self.co2Emissions = co2Emissions
        self.plasticWaste = plasticWaste
        self.waterSaved = waterSaved
        self.quantity = quantity
    }
    
    var image: UIImage {
        if let data = imageData {
            return UIImage(data: data) ?? UIImage(named: "product_placeholder")!
        }
        return UIImage(named: "product_placeholder")!
    }
}
