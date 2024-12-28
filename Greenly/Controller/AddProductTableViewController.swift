import UIKit
import FirebaseFirestore
import Cloudinary

protocol AddProductTableViewControllerDelegate: AnyObject {
    func didSaveProduct(_ product: Product, editingIndex: IndexPath?)
    func didSetStoreId(_ storeId: String) // method to setting storeId
}


class AddProductTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties
    var product: Product?
    var editingIndex: IndexPath?
    weak var delegate: AddProductTableViewControllerDelegate?
    let categories = ["Kitchen", "Cleaning", "Self Care"]
    var storeId: String? // Store ID of the store associated with this product 11
    let cloudinary = CloudinarySetup.cloudinarySetup()// cloudinary setup 11

    // Your existing initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // Add this custom initializer to accept a product
    init?(coder: NSCoder, product: Product?) {
        self.product = product
        super.init(coder: coder)
    }

    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextField: UITextField!
    @IBOutlet weak var productCategoryPickerView: UIPickerView!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productCO2TextField: UITextField!
    @IBOutlet weak var productPlasticTextField: UITextField!
    @IBOutlet weak var productWaterTextField: UITextField!
    @IBOutlet weak var productQuantityTextField: UITextField!
    @IBOutlet weak var productQuantityStepper: UIStepper!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Set delegate and data source for UIPickerView
        productCategoryPickerView.delegate = self
        productCategoryPickerView.dataSource = self

        // Automatically set storeId if it's nil
        if storeId == nil {
            storeId = fetchStoreId() // Fetch or generate the storeId
        }

        guard storeId != nil else {
            AlertHelper.showAlert(on: self, title: "Error", message: "Store ID is not set. Please ensure you are logged in as a store owner.")
            return
        }
    }

    private func fetchStoreId() -> String? {
        // Example logic to fetch storeId from UserDefaults or centralized session manager
        return UserDefaults.standard.string(forKey: "storeId")
    }

    private func setupUI() {
        if let product = product {
            title = "Edit Product"
            productNameTextField.text = product.name
            productDescriptionTextField.text = product.description
            if let index = categories.firstIndex(of: product.category) {
                productCategoryPickerView.selectRow(index, inComponent: 0, animated: false)
            }
            productPriceTextField.text = product.price
//            productImageView.image = product.imageUrl as UIImage
            if let imageUrlString = product.imageUrl, // Ensure the string is not nil
               let url = URL(string: imageUrlString) { // Convert the string to a URL
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: url), // Download the image data
                       let image = UIImage(data: imageData) { // Convert data to UIImage
                        DispatchQueue.main.async {
                            self.productImageView.image = image // Set the image in the UIImageView
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.productImageView.image = UIImage(named: "placeholder_image") // Set a placeholder if loading fails
                        }
                    }
                }
            } else {
                self.productImageView.image = UIImage(named: "placeholder_image") // Set a placeholder if the URL is invalid
            }
            productCO2TextField.text = product.co2Emissions
            productPlasticTextField.text = product.plasticWaste
            productWaterTextField.text = product.waterSaved
            productQuantityTextField.text = product.quantity
            productQuantityStepper.value = Double(product.quantity) ?? 0

            // Set storeId if editing
            storeId = product.storeId // Set storeId from the product
        } else {
            title = "Add New Product"
        }
    }

    //cancel button to stop editing
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Dismiss the view controller
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveProduct(_ sender: UIBarButtonItem) {
        guard let name = productNameTextField.text, !name.isEmpty,
              let description = productDescriptionTextField.text, !description.isEmpty,
              let price = productPriceTextField.text, !price.isEmpty,
              let co2Emissions = productCO2TextField.text, !co2Emissions.isEmpty,
              let plasticWaste = productPlasticTextField.text, !plasticWaste.isEmpty,
              let waterSaved = productWaterTextField.text, !waterSaved.isEmpty,
              let quantity = productQuantityTextField.text, !quantity.isEmpty,
              let category = categories[safe: productCategoryPickerView.selectedRow(inComponent: 0)],
              let storeId = storeId else {
            AlertHelper.showAlert(on: self, title: "Error", message: "Please fill all fields.")
            return
        }

        guard let productImage = productImageView.image else {
            AlertHelper.showAlert(on: self, title: "Error", message: "Please select an image.")
            return
        }

        // Upload the image to Cloudinary
        uploadImageToCloudinary(image: productImage) { [weak self] imageUrl in
            guard let self = self else { return }

            if let imageUrl = imageUrl {
                // Create the product object
                let product = Product(
                    name: name,
                    description: description,
                    category: category,
                    price: price,
                    image: productImage,
                    co2Emissions: co2Emissions,
                    plasticWaste: plasticWaste,
                    waterSaved: waterSaved,
                    quantity: quantity,
                    storeId: storeId,
                    imageUrl: imageUrl
                )

                // Save the product to Firestore with the imageUrl
                self.saveProductToFirestore(product: product, imageUrl: imageUrl)

                // Notify the delegate and dismiss the view controller
                self.delegate?.didSaveProduct(product, editingIndex: self.editingIndex)
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Image upload failed.")
                AlertHelper.showAlert(on: self, title: "Error", message: "Failed to upload image. Please try again.")
            }
        }
    }

    
    func saveProductToFirestore(product: Product, imageUrl: String) {
        guard let storeId = product.storeId else {
            print("DEBUG: Error - Missing storeId")
            return
        }

        let productData: [String: Any] = [
            "name": product.name,
            "description": product.description,
            "category": product.category,
            "price": product.price,
            "co2Emissions": product.co2Emissions,
            "plasticWaste": product.plasticWaste,
            "waterSaved": product.waterSaved,
            "quantity": product.quantity,
            "storeId": storeId,
            "imageUrl": product.imageUrl ?? ""
        ]

        print("DEBUG: Attempting to save productData to Firestore: \(productData)")

        let db = Firestore.firestore()
        db.collection("Products").addDocument(data: productData) { error in
            if let error = error {
                print("DEBUG: Firestore error - \(error.localizedDescription)")
            } else {
                print("DEBUG: Product added successfully to Firestore with imageUrl \(imageUrl)")
            }
        }
    }

    
    private func uploadImageToCloudinary(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("DEBUG: Error converting image to data")
            AlertHelper.showAlert(on: self, title: "Error", message: "Failed to process the image.")
            completion(nil)
            return
        }

        let uniqueID = UUID().uuidString
        let publicID = "products/\(uniqueID)"
        let uploadParams = CLDUploadRequestParams().setPublicId(publicID)

        cloudinary.createUploader().upload(data: imageData, uploadPreset: CloudinarySetup.uploadPreset, params: uploadParams, completionHandler:  { response, error in
            if let error = error {
                print("DEBUG: Cloudinary upload error - \(error.localizedDescription)")
                AlertHelper.showAlert(on: self, title: "Error", message: "Failed to upload image. Error: \(error.localizedDescription)")
                completion(nil)
            } else if let secureUrl = response?.secureUrl {
                print("DEBUG: Image uploaded successfully to \(secureUrl)")
                completion(secureUrl)
            } else {
                print("DEBUG: Unexpected error during Cloudinary upload")
                AlertHelper.showAlert(on: self, title: "Error", message: "Unexpected error during upload. Please try again.")
                completion(nil)
            }
        })
    }


    @IBAction func changeQuantity(_ sender: UIStepper) {
        productQuantityTextField.text = Int(sender.value).description
    }

    @IBAction func addImage(_ sender: UIButton) {
        showImageAlert()
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
            productImageView.image = image
        } else {
            print("Image not found")
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}

// Safe array index access
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
