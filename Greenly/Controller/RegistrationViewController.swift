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

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    //11
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var showRepeatPasswordButton: UIButton!//11

    

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
    }
    
    //11
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let buttonImage = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }
    
    @IBAction func showRepeatPasswordTapped(_ sender: UIButton) {
        repeatPasswordTextField.isSecureTextEntry.toggle()
        let buttonImage = repeatPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showRepeatPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }//11
    //Button11
//    @IBAction func registerButtonTapped(_ sender: UIButton) {
//        guard let email = emailTextField.text,
//              let password = passwordTextField.text,
//              let repeatPassword = repeatPasswordTextField.text,
//              password == repeatPassword else {
//            showAlert(title: "Error", message: "Passwords do not match.")
//            return
//        }
//
//        // Check if passwords match
//        if password != repeatPassword {
//            showAlert(title: "Error", message: "Passwords do not match.")
//            return // Stop further execution
//        }
//
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                self.showAlert(title: "Error", message: error.localizedDescription)
//                return
//            }
//            guard let user = authResult?.user else { return }
//
//            let db = Firestore.firestore()
//            db.collection("Users").document(user.uid).setData([
//                "firstName": self.firstNameTextField.text ?? "",
//                "lastName": self.lastNameTextField.text ?? "",
//                "email": email,
//                "role": "user"
//            ]) { error in
//                if let error = error {
//                    self.showAlert(title: "Error", message: error.localizedDescription)
//                } else {
//                    self.showAlert(title: "Success", message: "Account created successfully.")
//                }
//            }
//        }
//    }
    @IBAction func registerButtonTapped(_ sender: UIButton) {
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

        print("Starting Firebase user creation...")

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                print("Firebase error: \(error.localizedDescription)")
                return
            }

            guard let user = authResult?.user else {
                self.showAlert(title: "Error", message: "Failed to create account.")
                print("Failed to get user from Firebase auth result")
                return
            }

            print("Firebase user created successfully with UID: \(user.uid)")

            let db = Firestore.firestore()
            db.collection("Users").document(user.uid).setData([
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "password": password,
                "role": "user"
            ]) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to save user data: \(error.localizedDescription)")
                    print("Firestore error: \(error.localizedDescription)")
                } else {
                    let alert = UIAlertController(title: "Success", message: "Account created successfully.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        print("Firestore data saved successfully. Performing segue...")
                        self.performSegue(withIdentifier: "customerMainSegue", sender: self)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    
//    @IBAction func registerButtonTapped(_ sender: UIButton) {
//        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
//              let lastName = lastNameTextField.text, !lastName.isEmpty,
//              let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty,
//              let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty else {
//            showAlert(title: "Error", message: "All fields are required.")
//            return
//        }
//
//        // Check if passwords match
//        if password != repeatPassword {
//            showAlert(title: "Error", message: "Passwords do not match.")
//            return
//        }
//
//        // Proceed with Firebase Authentication
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                self.showAlert(title: "Error", message: error.localizedDescription)
//                return
//            }
//
//            // Ensure user is created successfully
//            guard let user = authResult?.user else {
//                self.showAlert(title: "Error", message: "Failed to create account.")
//                return
//            }
//
//            // Save additional user details in Firestore, including the plaintext password
//            let db = Firestore.firestore()
//            db.collection("Users").document(user.uid).setData([
//                "firstName": firstName,
//                "lastName": lastName,
//                "email": email,
//                "password": password, // Saving plaintext password (for academic purposes only)
//                "role": "user"
//            ]) { error in
//                if let error = error {
//                    self.showAlert(title: "Error", message: "Failed to save user data: \(error.localizedDescription)")
//                } else {
//                    self.showAlert(title: "Success", message: "Account created successfully.")
//                    self.performSegue(withIdentifier: "customerMainSegue", sender: self)
//                }
//            }
//        }
//    }

//    @IBAction func registerButtonTapped(_ sender: UIButton) {
//        // Validate input fields
//        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
//              let lastName = lastNameTextField.text, !lastName.isEmpty,
//              let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty,
//              let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty else {
//            showAlert(title: "Error", message: "All fields are required.")
//            return
//        }
//
//        // Check if passwords match
//        if password != repeatPassword {
//            showAlert(title: "Error", message: "Passwords do not match.")
//            return
//        }
//
//        // Proceed with Firebase Authentication
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                self.showAlert(title: "Error", message: error.localizedDescription)
//                return
//            }
//
//            // Ensure user is created successfully
//            guard let user = authResult?.user else {
//                self.showAlert(title: "Error", message: "Failed to create account.")
//                return
//            }
//
//            // Save additional user details in Firestore
//            let db = Firestore.firestore()
//            db.collection("Users").document(user.uid).setData([
//                "firstName": firstName,
//                "lastName": lastName,
//                "email": email,
//                "role": "user"
//            ]) { error in
//                if let error = error {
//                    self.showAlert(title: "Error", message: "Failed to save user data: \(error.localizedDescription)")
//                } else {
//                    // Navigate to the customer home screen only on success
//                    self.performSegue(withIdentifier: "customerMainSegue", sender: self)
//                }
//            }
//        }
//    }


    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}



////
////  RegistrationViewController.swift
////  Greenly
////
////  Created by BP-36-201-22 on 01/12/2024.
////
//
//import Foundation
//import FirebaseAuth
//import Firebase
//import UIKit
//
//class RegistrationViewController: UIViewController {
//    @IBOutlet weak var firstNameTextField: UITextField!
//    @IBOutlet weak var lastNameTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var repeatPasswordTextField: UITextField!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        passwordTextField.isSecureTextEntry = true
//        repeatPasswordTextField.isSecureTextEntry = true
//    }
//
//    @IBAction func showPasswordTapped(_ sender: UIButton) {
//        passwordTextField.isSecureTextEntry.toggle()
//        let buttonImage = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
//        showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
//    }
//
//    @IBAction func showRepeatPasswordTapped(_ sender: UIButton) {
//        repeatPasswordTextField.isSecureTextEntry.toggle()
//        let buttonImage = repeatPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
//        showRepeatPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
//    }
//
//    @IBAction func registerButtonTapped(_ sender: UIButton) {
//        guard let firstName = firstNameTextField.text,
//              let lastName = lastNameTextField.text,
//              let email = emailTextField.text,
//              let password = passwordTextField.text,
//              let repeatPassword = repeatPasswordTextField.text else { return }
//
//        if password != repeatPassword {
//            showAlert(title: "Error", message: "Passwords do not match.")
//            return
//        }
//
//        // Save user data to UserDefaults
//        let userData: [String: String] = [
//            "firstName": firstName,
//            "lastName": lastName,
//            "email": email
//        ]
//        print("Saving User Data: \(userData)") // Debug print
//        UserDefaults.standard.set(userData, forKey: "userProfile")
//
//        // Navigate to Edit Profile
////        if let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "SettingsTableViewController") as? EditProfileViewController {
////            editProfileVC.firstName = firstName
////            editProfileVC.lastName = lastName
////            editProfileVC.email = email
////            navigationController?.pushViewController(editProfileVC, animated: true)
////        }
//    }
//    func showAlert(title: String, message: String) {
//       let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//       alert.addAction(UIAlertAction(title: "OK", style: .default))
//       present(alert, animated: true)
//   }
//}
