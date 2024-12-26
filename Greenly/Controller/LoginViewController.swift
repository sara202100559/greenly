import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!//11

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        loginButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }

    @objc func textFieldChanged() {
        loginButton.isEnabled = !(emailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
    }
    
    //11
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let buttonImage = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }
    //11
    @IBAction func createAccountTapped(_ sender: UIButton) {
//        performSegue(withIdentifier: "showRegisterPage", sender: self)
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Login Error", message: error.localizedDescription)
                return
            }
            guard let user = authResult?.user else { return }
            
            let db = Firestore.firestore()
            db.collection("Users").document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    let role = document.data()?["role"] as? String
                    if role == "admin" {
                        self.performSegue(withIdentifier: "adminSegue", sender: self)
                    } else if role == "store owner" {
                        self.performSegue(withIdentifier: "storeOwnerSegue", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "userSegue", sender: self)
                    }
                }
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}



//import UIKit
//
//class LoginViewController: UIViewController {
//
//    // MARK: - Outlets
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var showPasswordButton: UIButton!
//
//    // MARK: - Lifecycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        passwordTextField.isSecureTextEntry = true
//        updateLoginButtonState()
//    }
//
//    // MARK: - Actions
//    @IBAction func loginButtonTapped(_ sender: UIButton) {
//        guard let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty else {
//            showAlert(title: "Error", message: "Please enter both email and password.")
//            return
//        }
//
//        // Authenticate user using sampleUsers
//        if let user = sampleUsers.first(where: { $0.email == email && $0.password == password }) {
//            switch user.role {
//            case "admin":
//                performSegue(withIdentifier: "adminSegue", sender: self)
//            case "store owner":
//                performSegue(withIdentifier: "storeOwnerSegue", sender: self)
//            case "user":
//                performSegue(withIdentifier: "userSegue", sender: self)
//            default:
//                showAlert(title: "Error", message: "Unknown user role.")
//            }
//        } else {
//            showAlert(title: "Error", message: "Invalid email or password.")
//        }
//    }
//
//    @IBAction func emailField(_ sender: Any) {
//        updateLoginButtonState()
//    }
//
//    @IBAction func passwordField(_ sender: Any) {
//        updateLoginButtonState()
//    }
//
//    @IBAction func showPasswordTapped(_ sender: UIButton) {
//        passwordTextField.isSecureTextEntry.toggle()
//        let buttonImage = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
//        showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
//    }
//
//    @IBAction func createAccountTapped(_ sender: UIButton) {
//        performSegue(withIdentifier: "showRegisterPage", sender: self)
//    }
//
//    // MARK: - Helper Methods
//    private func updateLoginButtonState() {
//        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
//        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
//        loginButton.isEnabled = !emailIsEmpty && !passwordIsEmpty
//    }
//
//    private func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true)
//    }
//}
