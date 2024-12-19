//
//  LoginViewController.swift
//  Greenly
//
//  Created by BP-36-201-22 on 01/12/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabaseInternal

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton! // Button to toggle password visibility

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true // Set initial password field state
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    
    // MARK: - Actions
    
    
        // Validate fields
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter both email and password.")
            return
        }
        // Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            
            if email.contains("admin".lowercased()){
                self.performSegue(withIdentifier: "admin", sender: sender)
            }
            else if email.contains("store".lowercased()){
                self.performSegue(withIdentifier: "Storeowner", sender: sender)
            }
            else {
                self.performSegue(withIdentifier: "CustHome", sender: sender)
            }
        }
    }

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

    // MARK: - Helper Functions
    private func getUserRole(for email: String, completion: @escaping (String) -> Void) {
        // Example method to get user role from Firebase database
        let databaseRef = Database.database().reference()
        let userUID = Auth.auth().currentUser?.uid ?? ""

        databaseRef.child("users").child(userUID).observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any],
                  let role = userData["role"] as? String else {
                completion("unknown")
                return
            }
            completion(role)
        }
    }

    private func navigateToStoreOwnerHomePage() {
        let storyboard = UIStoryboard(name: "StoreOwner", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "StoreOwnerHomeViewController") as? StoreOwnerHomeViewController {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Failed to instantiate StoreOwnerHomeViewController.")
        }
    }

//    private func navigateToCustomerHomePage() {
//        let storyboard = UIStoryboard(name: "CustomerHome", bundle: nil)
//        if let viewController = storyboard.instantiateViewController(withIdentifier: "CustomerHomeViewController") {
//            navigationController?.pushViewController(viewController, animated: true)
//        } else {
//            print("Failed to instantiate CustomerHomeViewController.")
//        }
//    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
