//
//  CartManager.swift
//  Greenly
//
//  Created by BP-36-208-07 on 28/12/2024.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    private init() {}

    var cartProducts: [CartProduct] = []

    func addProduct(_ product: CartProduct) {
        // Check if the product is already in the cart and update the quantity
        if let index = cartProducts.firstIndex(where: { $0.productId == product.productId }) {
            cartProducts[index].quantity = (cartProducts[index].quantity ?? 1) + (product.quantity ?? 1)
        } else {
            cartProducts.append(product)
        }
    }

    func getCartProducts() -> [CartProduct] {
        return cartProducts
    }
}

