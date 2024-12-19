//
//  CartModel.swift
//  MyProject
//
//  Created on 12/12/24.
//


struct CartResponseModel {
    var status: String?
    var response: CartResponse?
    var statusCode: Int?
}

// MARK: - CartResponse
struct CartResponse {
    var cartDetail: CartDetail?
}

// MARK: - CartDetail
struct CartDetail {
    var storeName: String?
    var products: [CartProduct]?
}

// Struct representing a cart item with its attributes.
// MARK: - Product
struct CartProduct {
    var productId: Int?
    var name: String?
    var price: Double?
    var image: String?
    var quantity: Int?
    var isChecked: Bool?
}
