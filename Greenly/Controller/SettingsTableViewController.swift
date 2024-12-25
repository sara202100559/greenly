//
//  SettingController.swift
//  Greenly
//
//  Created by BP-36-201-20 on 28/11/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func logoutBut(_ sender: UIButton) {
        // Show logout confirmation alert
        let alert = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            self.performLogout()
        })
        present(alert, animated: true)
    }
    
    private func performLogout() {
        do {
            try Auth.auth().signOut()
            navigateToMainStoryboard()
        } catch let error {
            showAlert(title: "Logout Error", message: error.localizedDescription)
        }
    }
    
    @IBAction func deleteBut(_ sender: UIButton) {
        // Show delete account confirmation alert
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.performAccountDeletion()
        })
        present(alert, animated: true)
    }
    
    private func performAccountDeletion() {
        guard let user = Auth.auth().currentUser else {
            showAlert(title: "Error", message: "No user is currently logged in.")
            return
        }
        
        let db = Firestore.firestore()
        
        // Delete user data from Firestore
        db.collection("Users").document(user.uid).delete { error in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to delete user data: \(error.localizedDescription)")
                return
            }
            
            // Delete user account from Firebase Authentication
            user.delete { error in
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to delete account: \(error.localizedDescription)")
                } else {
                    self.showAlert(title: "Success", message: "Account deleted successfully.") {
                        self.navigateToMainStoryboard()
                    }
                }
            }
        }
    }
    
    // MARK: - Edit Profile Action
    @IBAction func editProfileTapped(_ sender: Any) {
        if let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditProfile" {
            if let editProfileVC = segue.destination as? EditProfileViewController {
                // Fetch stored user data from UserDefaults
                if let userData = UserDefaults.standard.dictionary(forKey: "userProfile") as? [String: String] {
                    editProfileVC.firstName = userData["firstName"] ?? ""
                    editProfileVC.lastName = userData["lastName"] ?? ""
                    editProfileVC.email = userData["email"] ?? ""
                }
            }
        }
    }
    
    // MARK: - Navigation Methods
    private func navigateToMainStoryboard() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else {
            print("Failed to get SceneDelegate")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateInitialViewController() {
            sceneDelegate.window?.rootViewController = loginViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - Helper Alert Function
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
