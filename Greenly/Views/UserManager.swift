//
//  UserManager.swift
//  Greenly
//
//  Created by Sumaya janahi on 24/12/2024.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    private(set) var currentUser: User? // Using a computed property to get current user
    
    private init() { }
    
    // Function to authenticate user
    func authenticateUser(email: String, password: String) -> User? {
        // Authenticate user using sampleUsers
        if let user = sampleUsers.first(where: { $0.email == email && $0.password == password }) {
            currentUser = user // Set the current user
            return user
        }
        return nil // Return nil if authentication fails
    }
    
    // Logout function
    func logout() {
        currentUser = nil
    }
}
