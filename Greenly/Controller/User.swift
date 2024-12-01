//
//  User.swift
//  Greenly
//
//  Created by BP-36-201-22 on 01/12/2024.
//

import Foundation


struct User {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var role: String // "user", "store owner", "admin"
}

let sampleUsers: [User] = [
    // Sample Users (Customers)
    User(firstName: "Sara", lastName: "Alhashimi", email: "Sara_alhashimi@gmail.com", password: "SaraAlhashimi123", role: "user"),
    User(firstName: "Maryam", lastName: "Alsafar", email: "Maryam_Alsafar@gmail.com", password: "MaryamAlsafar123", role: "user"),
    User(firstName: "Sumaya", lastName: "Janahi", email: "Sumaya_Janahi@gmail.com", password: "SumayaJanahi123", role: "user"),
    User(firstName: "Fatima", lastName: "Alburaki", email: "Fatima_Alburaki@gmail.com", password: "FatimaAlburaki123", role: "user"),
    User(firstName: "Qamreen", lastName: "Hasan", email: "Qamreen_Hasan@gmail.com", password: "QamreenHasan123", role: "user"),

    // Sample Store Owners
    User(firstName: "Zws", lastName: "", email: "zws@store.com", password: "Zws123", role: "store owner"),
    User(firstName: "Urban", lastName: "Kissed", email: "urbankissed@store.com", password: "Urban123", role: "store owner"),
    User(firstName: "Eco", lastName: "Friendly", email: "storeecofriendly@store.com", password: "Eco123", role: "store owner"),
    User(firstName: "Public", lastName: "Good", email: "publicgood@store.com", password: "Public123", role: "store owner"),
    User(firstName: "Package", lastName: "Free", email: "packagefree@store.com", password: "Package123", role: "store owner"),
    User(firstName: "Made", lastName: "Trade", email: "madetrade@store.com", password: "MadeTrade123", role: "store owner"),
    User(firstName: "Grove", lastName: "Collaborative", email: "grovecollaborative@store.com", password: "GroveCollaborative123", role: "store owner"),
    User(firstName: "Ethical", lastName: "Superstore", email: "ethicalsuperstore@store.com", password: "EthicalSuperstore123", role: "store owner"),
    User(firstName: "Earth", lastName: "Hero", email: "earthhero@store.com", password: "EarthHero123", role: "store owner"),
    User(firstName: "Done", lastName: "Good", email: "donegood@store.com", password: "DoneGood123", role: "store owner"),

    // Admin User
    User(firstName: "Admin", lastName: "", email: "admin@admin.com", password: "Admin123", role: "admin")
]
