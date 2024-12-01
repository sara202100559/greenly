//
//  LoginViewController.swift
//  Greenly
//
//  Created by BP-36-201-22 on 01/12/2024.
//

import Foundation

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
           guard let email = emailTextField.text, let password = passwordTextField.text else { return }

           for user in sampleUsers {
               if user.email == email && user.password == password {
                   // Check user role and navigate to the appropriate home page
                   switch user.role {
                   case "admin":
                       performSegue(withIdentifier: "showAdminHomePage", sender: self)
                   case "store owner":
                       performSegue(withIdentifier: "showStoreOwnerHomePage", sender: self)
                   default:
                       performSegue(withIdentifier: "showUserHomePage", sender: self)
                   }
                   return
               }
           }


        // Show error message
        let alert = UIAlertController(title: "Error", message: "Invalid email or password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func createAccountTapped(_ sender: UIButton) {
        // Navigate to the registration page
        performSegue(withIdentifier: "showRegisterPage", sender: self)
    }
}
