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
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var showRepeatPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
    }
    
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
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let repeatPassword = repeatPasswordTextField.text else { return }

        if password != repeatPassword {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }

        // Save user data to UserDefaults
        let userData: [String: String] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]
        print("Saving User Data: \(userData)") // Debug print
        UserDefaults.standard.set(userData, forKey: "userProfile")
        
        // Navigate to Edit Profile
        if let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "SettingsTableViewController") as? EditProfileViewController {
            editProfileVC.firstName = firstName
            editProfileVC.lastName = lastName
            editProfileVC.email = email
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }  
    func showAlert(title: String, message: String) {
       let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default))
       present(alert, animated: true)
   }
}
