//
//  Order.swift
//  Greenly
//
//  Created by BP-36-201-02 on 19/12/2024.
//

struct Order: Codable {
    var id: String
    var status: OrderStatus
    var date: String
    var price: Double
    var ownerName: String
    var feedback: String?
    var rating: Int?
    
    //Extra
    var storeName: String
    var items: [OrderItem]
    var paymentMethod: String
}
struct OrderItem: Codable {
    let name: String
    let price: String
    let quantity: String
}
enum OrderStatus: String, Codable {
    case pending = "Pending"
    case delivering = "Delivering"
    case delivered = "Delivered"
}
