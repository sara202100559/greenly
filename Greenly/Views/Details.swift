//
//  Details.swift
//  Greenly
//
//  Created by BP-36-201-01 on 15/12/2024.
//
import UIKit

class Details {
    var id: String // Firestore document ID
    var name: String
    var email: String
    var num: String
    var pass: String
    var image: UIImage
    var location: String
    var web: String
    var from: String
    var to: String
    var logoUrl: String

    init(id: String, name: String, email: String, num: String, pass: String, image: UIImage, location: String, web: String, from: String, to: String, logoUrl: String) {
        self.id = id
        self.name = name
        self.email = email
        self.num = num
        self.pass = pass
        self.image = image
        self.location = location
        self.web = web
        self.from = from
        self.to = to
        self.logoUrl = logoUrl
    }
}
