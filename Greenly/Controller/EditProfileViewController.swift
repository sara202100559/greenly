import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - Properties
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
    }

    private func setupUI() {
        // Disable editing for email and password fields
        emailTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        passwordTextField.isSecureTextEntry = true // Hide password for security
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

                DispatchQueue.main.async {
                    self.firstNameTextField.text = self.firstName
                    self.lastNameTextField.text = self.lastName
                    self.emailTextField.text = self.email
                    self.passwordTextField.text = "**" // Placeholder for password (optional for security)
                }
            }
        }
    }

    @IBAction func saveProfileTapped(_ sender: UIBarButtonItem) {
        guard let updatedFirstName = firstNameTextField.text, !updatedFirstName.isEmpty,
              let updatedLastName = lastNameTextField.text, !updatedLastName.isEmpty else {
            showAlert(title: "Error", message: "First and Last Name cannot be empty.")
            return
        }

        guard let user = Auth.auth().currentUser else {
            showAlert(title: "Error", message: "No user is logged in.")
            return
        }

        let db = Firestore.firestore()
        db.collection("Users").document(user.uid).updateData([
            "firstName": updatedFirstName,
            "lastName": updatedLastName
        ]) { error in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to update user data: \(error.localizedDescription)")
            } else {
                self.showAlert(title: "Success", message: "Profile updated successfully.") {
                    self.navigationController?.popViewController(animated: true)
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
