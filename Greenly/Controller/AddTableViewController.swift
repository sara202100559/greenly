//
//  AddTableViewController.swift
//  Greenly
//
//  Created by BP-36-201-16N on 27/11/2024.
//

import UIKit
import FirebaseFirestore
import Cloudinary

protocol AddTableViewControllerDelegate: AnyObject {
    func didSaveStore(_ store: Details, editingIndex: IndexPath?)
}

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    var details: Details?
    var editingIndex: IndexPath?
    weak var delegate: AddTableViewControllerDelegate?
    let cloudinary = CloudinarySetup.cloudinarySetup()

    // MARK: - Outlets
    @IBOutlet weak var StoreLogo: UIImageView!
    @IBOutlet weak var StoreName: UITextField!
    @IBOutlet weak var StoreEmail: UITextField!
    @IBOutlet weak var StoreNumber: UITextField!
    @IBOutlet weak var StorePassword: UITextField!
    @IBOutlet weak var StoreLocation: UITextField!
    @IBOutlet weak var StoreWebsite: UITextField!
    @IBOutlet weak var StoreFrom: UITextField!
    @IBOutlet weak var StoreTo: UITextField!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupUI() {
        if let details = details {
            title = "Edit Store Details"
            StoreName.text = details.name
            StoreEmail.text = details.email
            StoreNumber.text = details.num
            StorePassword.text = details.pass
            StoreLocation.text = details.location
            StoreWebsite.text = details.web
            StoreFrom.text = details.from
            StoreTo.text = details.to

            // Dynamically load the logo image from the URL
            if let url = URL(string: details.logoUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.StoreLogo.image = image
                        }
                    }
                }
            }
        } else {
            title = "Add New Store"
        }
    }

    init?(coder: NSCoder, store: Details?) {
        self.details = store
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func SaveAdded(_ sender: UIBarButtonItem) {
        guard let name = StoreName.text, !name.isEmpty,
              let email = StoreEmail.text, !email.isEmpty,
              let num = StoreNumber.text, !num.isEmpty,
              let pass = StorePassword.text, !pass.isEmpty,
              let location = StoreLocation.text, !location.isEmpty,
              let web = StoreWebsite.text, !web.isEmpty,
              let from = StoreFrom.text, !from.isEmpty,
              let to = StoreTo.text, !to.isEmpty else {
            AlertHelper.showAlert(on: self, title: "Error", message: "Please fill all the fields")
            return
        }

        guard let logoImage = StoreLogo.image else {
            AlertHelper.showAlert(on: self, title: "Error", message: "Please select a store logo")
            return
        }

        uploadImageToCloudinary(image: logoImage) { [weak self] (imageUrl: String?) in
            guard let self = self else { return }
            guard let imageUrl = imageUrl else {
                AlertHelper.showAlert(on: self, title: "Error", message: "Failed to upload the logo image")
                return
            }

            let storeData: [String: Any] = [
                "name": name,
                "email": email,
                "number": num,
                "password": pass,
                "location": location,
                "website": web,
                "from": from,
                "to": to,
                "logoUrl": imageUrl
            ]

            let db = Firestore.firestore()

            // Check if editing an existing store
            if let details = self.details, !details.id.isEmpty {
                // Update the existing Firestore document
                db.collection("Stores").document(details.id).updateData(storeData) { error in
                    if let error = error {
                        print("Error updating store: \(error.localizedDescription)")
                        AlertHelper.showAlert(on: self, title: "Error", message: "Failed to update store details")
                    } else {
                        print("Store updated successfully!")
                        let updatedStore = Details(
                            id: details.id,
                            name: name,
                            email: email,
                            num: num,
                            pass: pass,
                            image: logoImage,
                            location: location,
                            web: web,
                            from: from,
                            to: to,
                            logoUrl: imageUrl
                        )
                        self.delegate?.didSaveStore(updatedStore, editingIndex: self.editingIndex)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                // Add a new Firestore document
                db.collection("Stores").addDocument(data: storeData) { error in
                    if let error = error {
                        print("Error saving store: \(error.localizedDescription)")
                        AlertHelper.showAlert(on: self, title: "Error", message: "Failed to save store details")
                    } else {
                        print("Store saved successfully!")
                        let newStore = Details(
                            id: "", // Firestore will generate an ID
                            name: name,
                            email: email,
                            num: num,
                            pass: pass,
                            image: logoImage,
                            location: location,
                            web: web,
                            from: from,
                            to: to,
                            logoUrl: imageUrl
                        )
                        self.delegate?.didSaveStore(newStore, editingIndex: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    private func uploadImageToCloudinary(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            completion(nil)
            return
        }

        let uniqueID = UUID().uuidString
        let publicID = "images/stores/\(uniqueID)"
        let uploadParams = CLDUploadRequestParams().setPublicId(publicID)

        cloudinary.createUploader().upload(data: imageData, uploadPreset: CloudinarySetup.uploadPreset, params: uploadParams, completionHandler:  { response, error in
            if let error = error {
                print("Cloudinary upload error: \(error.localizedDescription)")
                completion(nil)
            } else if let secureUrl = response?.secureUrl {
                print("Image uploaded successfully: \(secureUrl)")
                completion(secureUrl)
            } else {
                print("Unknown error occurred during Cloudinary upload")
                completion(nil)
            }
        })
    }
    
    @IBAction func Logo(_ sender: Any) {
        showImageAlert()
    }

    @IBAction func cancle(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    private func showImageAlert() {
        let alert = UIAlertController(title: "Take Photo From", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.getPhoto(type: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func getPhoto(type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            StoreLogo.image = image
        } else {
            print("Image not found")
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    private func isValidURL(_ url: String) -> Bool {
        return URL(string: url) != nil
    }

    private func isValidTime(_ time: String) -> Bool {
        let timeRegEx = "^(0?[1-9]|1[0-2]):[0-5][0-9]\\s?(AM|PM)$"
        return NSPredicate(format: "SELF MATCHES %@", timeRegEx).evaluate(with: time)
    }
}
