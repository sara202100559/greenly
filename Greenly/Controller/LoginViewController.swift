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
    @IBOutlet weak var showPasswordButton: UIButton! // Button to toggle password visibility

    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Set initial state for password field
            passwordTextField.isSecureTextEntry = true
        }

    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        for user in sampleUsers {
            if user.email == email && user.password == password {
                // Check user role and navigate to the appropriate home page
                switch user.role {
                case "admin":
                    // Navigate to Admin Home Page
                    let storyboard = UIStoryboard(name: "Admin", bundle: nil)
                    let adminVC = storyboard.instantiateViewController(withIdentifier: "AdminHomeViewController") as! StoresTableViewController
                    //adminVC.modalPresentationStyle = .fullScreen
                    self.performSegue(withIdentifier: "admin", sender: nil)

                case "store owner":
                    // Navigate to Store Owner Home Page
                    navigateToStoreOwnerHomePage()

                case "user":
                    // Navigate to Customer Home Page
                    let storyboard = UIStoryboard(name: "CustomerHome", bundle: nil)
                    let customerVC = storyboard.instantiateViewController(withIdentifier: "CustomerHomeViewController")
                    customerVC.modalPresentationStyle = .fullScreen
                    self.present(customerVC, animated: true) {
                        self.view.window?.rootViewController = customerVC
                    }

                default:
                    break
                }
                return
            }
        }

        // Show error message
        let alert = UIAlertController(title: "Error", message: "Invalid email or password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
//    @IBAction func loginButtonTapped(_ sender: UIButton) {
//           guard let email = emailTextField.text, let password = passwordTextField.text else { return }
//
//           for user in sampleUsers {
//               if user.email == email && user.password == password {
//                   // Check user role and navigate to the appropriate home page
//                   switch user.role {
//                   case "admin":
//                       performSegue(withIdentifier: "showAdminHomePage", sender: self)
//                   case "store owner":
//                                   navigateToStoreOwnerHomePage()
//                   case "user":
//                                  // Use segue to navigate to the customer home page
//                                  performSegue(withIdentifier: "showHomePage", sender: self)
//                   default:
//                       break
//                   }
//                   return
//               }
//           }
//
//
//        // Show error message
//        let alert = UIAlertController(title: "Error", message: "Invalid email or password.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
    
    
    // Function to navigate to the Store Owner Home Page
    func navigateToStoreOwnerHomePage() {
        let storyboard = UIStoryboard(name: "StoreOwner", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "StoreOwnerHomeViewController") as? StoreOwnerHomeViewController {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Failed to instantiate StoreOwnerHomeViewController.")
        }
    }
    
//    func navigateToCustomerHomePage() {
//        let storyboard = UIStoryboard(name: "CustomerHome", bundle: nil) // Make sure the name is correct
//        if let viewController = storyboard.instantiateViewController(withIdentifier: "CustomerHomeViewController") as? CustomerHomeViewController {
//            navigationController?.pushViewController(viewController, animated: true)
//        } else {
//            print("Failed to instantiate CustomerHomeViewController.")
//        }
//    }
    
    
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        // Toggle secure text entry
        passwordTextField.isSecureTextEntry.toggle()
        
        // Change button appearance based on password visibility
        let buttonImage = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }

    @IBAction func createAccountTapped(_ sender: UIButton) {
        // Navigate to the registration page
        performSegue(withIdentifier: "showRegisterPage", sender: self)
    }
}
