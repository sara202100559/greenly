import UIKit
import FirebaseFirestore
import Cloudinary
import FirebaseAuth

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
            AlertHelper.showAlert(on: self, title: "Error", message: "Please fill all the fields.")
            return
        }

        guard let logoImage = StoreLogo.image else {
            AlertHelper.showAlert(on: self, title: "Error", message: "Please provide a logo image.")
            return
        }

        // Upload image to Cloudinary
        uploadImageToCloudinary(image: logoImage) { [weak self] logoUrl in
            guard let self = self, let logoUrl = logoUrl else {
                AlertHelper.showAlert(on: self!, title: "Error", message: "Failed to upload logo.")
                return
            }

            // Create Firebase Auth user
            Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                if let error = error {
                    print("Error creating user: \(error.localizedDescription)")
                    AlertHelper.showAlert(on: self, title: "Error", message: "Failed to create user account.")
                    return
                }

                guard let userId = authResult?.user.uid else {
                    AlertHelper.showAlert(on: self, title: "Error", message: "Failed to retrieve user ID.")
                    return
                }

                // Store data in Firestore
                let db = Firestore.firestore()
                let storeData: [String: Any] = [
                    "userId": userId,
                    "name": name,
                    "email": email,
                    "number": num,
                    "location": location,
                    "website": web,
                    "from": from,
                    "to": to,
                    "logoUrl": logoUrl
                ]

                db.collection("Stores").addDocument(data: storeData) { error in
                    if let error = error {
                        print("Error saving store: \(error.localizedDescription)")
                        AlertHelper.showAlert(on: self, title: "Error", message: "Failed to save store details.")
                        return
                    }

                    print("Store saved successfully!")

                    // Save user data
                    let userData: [String: Any] = [
                        "userId": userId,
                        "email": email,
                        "role": "store owner"
                    ]

                    db.collection("Users").document(userId).setData(userData) { error in
                        if let error = error {
                            print("Error saving user: \(error.localizedDescription)")
                            AlertHelper.showAlert(on: self, title: "Error", message: "Failed to save user details.")
                        } else {
                            print("User saved successfully!")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func uploadImageToCloudinary(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            AlertHelper.showAlert(on: self, title: "Error", message: "Failed to process the image.")
            completion(nil)
            return
        }

        let uniqueID = UUID().uuidString
        let publicID = "images/stores/\(uniqueID)"
        let uploadParams = CLDUploadRequestParams().setPublicId(publicID)

        cloudinary.createUploader().upload(data: imageData, uploadPreset: CloudinarySetup.uploadPreset, params: uploadParams, completionHandler:  { response, error in
            if let error = error {
                print("Cloudinary upload error: \(error.localizedDescription)")
                AlertHelper.showAlert(on: self, title: "Error", message: "Failed to upload logo. Error: \(error.localizedDescription)")
                completion(nil)
            } else if let secureUrl = response?.secureUrl {
                print("Image uploaded successfully. URL: \(secureUrl)")
                completion(secureUrl)
            } else {
                print("Unexpected error during Cloudinary upload")
                AlertHelper.showAlert(on: self, title: "Error", message: "Unexpected error during upload. Please try again.")
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
}
