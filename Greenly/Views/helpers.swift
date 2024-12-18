//
//  helpers.swift
//  Greenly
//
//  Created by BP-36-201-01 on 15/12/2024.
//

import Foundation
import UIKit

class ValidationHelper {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    static func isValidURL(_ url: String) -> Bool {
        return URL(string: url) != nil
    }

    static func isValidTime(_ time: String) -> Bool {
        let timeRegEx = "^(0?[1-9]|1[0-2]):[0-5][0-9]\\s?(AM|PM)$"
        return NSPredicate(format: "SELF MATCHES %@", timeRegEx).evaluate(with: time)
    }
}

class AlertHelper {
    // Show alert with dynamic title and message
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }

    // Predefined alerts for specific validation issues
    static func showEmptyFieldAlert(on viewController: UIViewController, fieldName: String) {
        showAlert(on: viewController, title: "Error", message: "\(fieldName) cannot be empty.")
    }

    static func showInvalidFormatAlert(on viewController: UIViewController, fieldName: String, formatHint: String) {
        showAlert(on: viewController, title: "Invalid Input", message: "\(fieldName) must be in the format: \(formatHint).")
    }
}
