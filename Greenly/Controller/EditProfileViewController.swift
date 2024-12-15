import UIKit

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
        if let userData = UserDefaults.standard.dictionary(forKey: "userProfile") as? [String: String] {
            print("Loaded User Data: \(userData)") // Debug print
            firstName = userData["firstName"] ?? ""
            lastName = userData["lastName"] ?? ""
            email = userData["email"] ?? ""
        } else {
            print("No data found in UserDefaults.")
        }
    }

    private func setupUI() {
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        emailTextField.text = email
        emailTextField.isUserInteractionEnabled = false // Read-only
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        // Retrieve user data from UserDefaults
        if let userData = UserDefaults.standard.dictionary(forKey: "userProfile") as? [String: String],
           let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            
            // Pass the user data
            editProfileVC.firstName = userData["firstName"] ?? ""
            editProfileVC.lastName = userData["lastName"] ?? ""
            editProfileVC.email = userData["email"] ?? ""
            
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    @IBAction func SaveProfile(_ sender: UIBarButtonItem) {
        guard let updatedFirstName = firstNameTextField.text,
              let updatedLastName = lastNameTextField.text else {
            showAlert(title: "Error", message: "Fields cannot be empty.")
            return
        }

        // Update and save user data to UserDefaults
        var userData = UserDefaults.standard.dictionary(forKey: "userProfile") as? [String: String] ?? [:]
        userData["firstName"] = updatedFirstName
        userData["lastName"] = updatedLastName
        UserDefaults.standard.set(userData, forKey: "userProfile")

        // Show success alert and navigate back
        showAlert(title: "Success", message: "Profile updated successfully.") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    // Helper function to show alert
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
