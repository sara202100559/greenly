//
//  UserDefaults+Order.swift
//  Greenly
//
//  Created by BP-36-208-19 on 28/12/2024.
//

import Foundation

extension UserDefaults {
    private static let ordersKey = "ordersKey"

    func saveOrders(_ orders: [Order]) {
        if let encodedData = try? JSONEncoder().encode(orders) {
            set(encodedData, forKey: UserDefaults.ordersKey)
        }
    }

    func loadOrders() -> [Order] {
        if let data = data(forKey: UserDefaults.ordersKey),
           let decodedOrders = try? JSONDecoder().decode([Order].self, from: data) {
            return decodedOrders
        }
        return []
    }
}
