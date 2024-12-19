//
//  Order.swift
//  Greenly
//
//  Created by BP-36-201-02 on 19/12/2024.
//

import Foundation
struct Order: Codable {
    let storeName: String
    let date: String
    let orderID: String
    let price: String
    let status: String
}
