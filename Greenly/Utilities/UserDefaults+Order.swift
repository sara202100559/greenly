//
//  UserDefaults+Order.swift
//  Greenly
//
//  Created by BP-36-201-02 on 19/12/2024.
//

import Foundation

extension UserDefaults {
    func saveOrders(_ orders: [Order]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(orders) {
            set(encoded, forKey: "orderHistory")
        }
    }

    func loadOrders() -> [Order] {
        if let savedData = data(forKey: "orderHistory"),
           let decoded = try? JSONDecoder().decode([Order].self, from: savedData) {
            return decoded
        }
        return []
    }
}
