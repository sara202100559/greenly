//
//  RegistrationViewController.swift
//  Greenly
//
//  Created by BP-36-201-22 on 01/12/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var showRepeatPasswordButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
    }

    // MARK: - Actions
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let buttonImage = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }

    @IBAction func showRepeatPasswordTapped(_ sender: UIButton) {
        repeatPasswordTextField.isSecureTextEntry.toggle()
        let buttonImage = repeatPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showRepeatPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Validate input fields
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty else {
            showAlert(title: "Error", message: "All fields are required.")
            return
        }

        if password != repeatPassword {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }

        // Start Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                print("Firebase error: \(error.localizedDescription)")
                return
            }

            // Get the user ID
            guard let userID = authResult?.user.uid else {
                self.showAlert(title: "Error", message: "Failed to create account.")
                return
            }

            print("User created successfully with UID: \(userID)")

            // Save user data in Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "userId": userID, // Explicitly save the user ID
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "role": "user" // Default role for a new user
            ]

            db.collection("Users").document(userID).setData(userData) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to save user data: \(error.localizedDescription)")
                    print("Firestore error: \(error.localizedDescription)")
                } else {
                    print("User data saved to Firestore successfully.")
                    let alert = UIAlertController(title: "Success", message: "Account created successfully.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "customerMainSegue", sender: self)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    // MARK: - Helper Methods
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
