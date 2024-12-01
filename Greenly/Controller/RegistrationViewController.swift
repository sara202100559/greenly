//
//  RegistrationViewController.swift
//  Greenly
//
//  Created by BP-36-201-22 on 01/12/2024.
//

import Foundation

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

        // Save the new user (in a real app, you would save this to a database)
        let newUser = User(firstName: firstName, lastName: lastName, email: email, password: password, role: "user")
        // Here you could append to an array or save to a database
        // sampleUsers.append(newUser)

        // Navigate to the home page
        performSegue(withIdentifier: "showHomePage", sender: self)
    }
}
