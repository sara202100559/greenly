//
//  RegistrationViewController.swift
//  Greenly
//
//  Created by BP-36-201-22 on 01/12/2024.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton! // Button to toggle password visibility
    @IBOutlet weak var showRepeatPasswordButton: UIButton! // Button to toggle repeat password visibility

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial state for password fields
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
    }
    
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        // Toggle secure text entry for password field
        passwordTextField.isSecureTextEntry.toggle()

        // Change button appearance based on password visibility
        let buttonImage = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }

    @IBAction func showRepeatPasswordTapped(_ sender: UIButton) {
        // Toggle secure text entry for repeat password field
        repeatPasswordTextField.isSecureTextEntry.toggle()

        // Change button appearance based on password visibility
        let buttonImage = repeatPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showRepeatPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let repeatPassword = repeatPasswordTextField.text else { return }

        if password != repeatPassword {
            // Show error message
            let alert = UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        

        // Register the user with Firebase Authentication
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        // Show error message
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        return
                    }

                    // User registration successful, save additional data to Firestore
                    guard let userId = authResult?.user.uid else { return }
                    let userData: [String: Any] = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "role": "user" // Set user role as needed
                    ]

                    // Save to Firestore
                    Firestore.firestore().collection("users").document(userId).setData(userData) { error in
                        if let error = error {
                            // Show error message
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        } else {
                            // Navigate to the home page
                            self.performSegue(withIdentifier: "showHomePage", sender: self)
                        }
                    }
                }
    }
}
