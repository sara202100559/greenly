//
//  Details.swift
//  Greenly
//
//  Created by BP-36-201-01 on 15/12/2024.
//
import UIKit

struct Details: Codable {
    var name: String
    var email: String
    var num: String
    var pass: String
    var imageData: Data?
    var location: String
    var web: String
    var from: String
    var to: String

    init(name: String, email: String, num: String, pass: String, image: UIImage, location: String, web: String, from: String, to: String) {
        self.name = name
        self.email = email
        self.num = num
        self.pass = pass
        self.imageData = image.pngData()
        self.location = location
        self.web = web
        self.from = from
        self.to = to
    }

    var image: UIImage {
        if let imageData = imageData {
            return UIImage(data: imageData) ?? UIImage(named: "storefront")!
        }
        return UIImage(named: "storefront")!
    }
}

