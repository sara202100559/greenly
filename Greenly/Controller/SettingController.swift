//
//  SettingController.swift
//  Greenly
//
//  Created by BP-36-201-20 on 28/11/2024.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions for Buttons
    
    @IBAction func logoutBut(_ sender: UIButton) {
        // Show logout confirmation alert
        let alert = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            self.navigateToMainStoryboard()
        })
        present(alert, animated: true)
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
            // Simulate account deletion
            let confirmation = UIAlertController(
                title: "Account Deleted",
                message: "Your account has been successfully deleted.",
                preferredStyle: .alert
            )
            confirmation.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigateToMainStoryboard()
            })
            self.present(confirmation, animated: true)
        })
        present(alert, animated: true)
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
}
