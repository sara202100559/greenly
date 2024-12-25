import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Properties
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        setupUI()
    }
    
    private func loadUserData() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Users").document(user.uid).getDocument { document, error in
            if let error = error {
                print("Error loading user data: \(error.localizedDescription)")
                return
            }
            
            if let data = document?.data() {
                self.firstName = data["firstName"] as? String ?? ""
                self.lastName = data["lastName"] as? String ?? ""
                self.email = data["email"] as? String ?? ""
                
                self.setupUI()
            }
        }
    }
    
    private func setupUI() {
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        emailTextField.text = email
    }
    
    @IBAction func saveProfileTapped(_ sender: UIBarButtonItem) {
        guard let updatedFirstName = firstNameTextField.text, !updatedFirstName.isEmpty,
              let updatedLastName = lastNameTextField.text, !updatedLastName.isEmpty,
              let updatedEmail = emailTextField.text, !updatedEmail.isEmpty else {
            showAlert(title: "Error", message: "All fields must be filled out.")
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            showAlert(title: "Error", message: "No user is logged in.")
            return
        }
        
        let db = Firestore.firestore()
        
        // Update Firestore first
        db.collection("Users").document(user.uid).updateData([
            "firstName": updatedFirstName,
            "lastName": updatedLastName,
            "email": updatedEmail
        ]) { error in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to update user data: \(error.localizedDescription)")
                return
            }
            
            // Check if the email has changed
            if self.email != updatedEmail {
                // Reauthenticate the user before updating the email
                self.reauthenticateUser { success in
                    if success {
                        self.sendVerificationForEmailUpdate(newEmail: updatedEmail) { success, message in
                            if success {
                                self.showAlert(title: "Email Updated", message: message ?? "A verification email has been sent. Please verify your new email.") {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            } else {
                                self.showAlert(title: "Error", message: message ?? "Unknown error occurred.")
                            }
                        }
                    } else {
                        self.showAlert(title: "Error", message: "Reauthentication failed. Please try again.")
                    }
                }
            } else {
                self.showAlert(title: "Success", message: "Profile updated successfully.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func reauthenticateUser(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        let alertController = UIAlertController(
            title: "Reauthenticate",
            message: "Please enter your password to confirm your identity.",
            preferredStyle: .alert
        )

        alertController.addTextField { passwordField in
            passwordField.placeholder = "Password"
            passwordField.isSecureTextEntry = true
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        })

        alertController.addAction(UIAlertAction(title: "Reauthenticate", style: .default) { _ in
            guard let password = alertController.textFields?.first?.text, !password.isEmpty else {
                completion(false)
                return
            }

            let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: password)
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    print("Reauthentication failed: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        })

        self.present(alertController, animated: true)
    }
    
    private func sendVerificationForEmailUpdate(newEmail: String, completion: @escaping (Bool, String?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, "No user is logged in.")
            return
        }

        user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
            if let error = error {
                completion(false, "Failed to send verification email: \(error.localizedDescription)")
            } else {
                do {
                    try Auth.auth().signOut()
                    completion(true, "A verification email has been sent to your new email address. Please verify it before logging in again.")
                } catch let signOutError {
                    completion(false, "Failed to log out: \(signOutError.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
