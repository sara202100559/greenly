//
//  ImpactData.swift
//  tracker
//
//  Created by BP-36-201-22 on 20/12/2024.
//

import Foundation

class ImpactData {
    // Singleton instance
    static let shared = ImpactData()

    // Dictionary to store chart data
    var chartData: [String: Double] = [:] // Store impact values for categories

    private init() {} // Private initializer to prevent instantiation
    


      
        // Method to reset the impact data to default values
        func resetToDefaultValues() {
            chartData = [
                "Plastic Waste Reduction Product": 2.0,
                "Water Conservation Product": 3.0,
                "Carbon Emission Reduction": 2.0,
                "Others": 0.5
            ]
        }
    }
