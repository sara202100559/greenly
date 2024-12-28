//
//  CloudinarySetup.swift
//  Greenly
//
//  Created by Sumaya janahi on 24/12/2024.
//

import Foundation
import Cloudinary

struct CloudinarySetup {
    
    static var cloudinary: CLDCloudinary!
    
    // Cloudinary credentials
    private static let cloudName: String = "dlltooaqi"
    private static let apiKey: String = "465467872752354" // Replace with your actual API Key
    private static let apiSecret: String = "B23T2" // Replace with your actual API Secret
    static let uploadPreset: String = "ml_default" // Your upload preset (unsigned or signed)

    static func cloudinarySetup() -> CLDCloudinary {
        if cloudinary == nil {
            // Configure Cloudinary with signed credentials for more control
            let config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret, secure: true)
            cloudinary = CLDCloudinary(configuration: config)
        }
        return cloudinary
    }
}
