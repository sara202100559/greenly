//
//  ProductDetailsViewController.swift
//  Greenly
//
//  Created by Sumaya janahi on 15/12/2024.
//

import UIKit


    // Product model for storing product details
    struct Product {
        var name: String
        var description: String
        var category: String
        var price: Double
        var co2: Double
        var plasticWaste: Double
        var waterSaved: Double
        var quantity: Int
        var image: UIImage?
    }

    class ProductDetailsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        // Outlets
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

        // Categories for Picker View
        let categories = ["Kitchen", "Cleaning", "Self Care"]

        // Instance of the product being edited or added
        var product: Product?
        
        struct AlertMessages {
            static let validationErrorTitle = "Validation Error"
            static let validationErrorMessage = "Please fill in all fields before saving."
            static let successUpdateTitle = "Updated"
            static let successUpdateMessage = "Product details have been updated successfully!"
            static let successCreateTitle = "Created"
            static let successCreateMessage = "New product has been added successfully!"
        }


        override func viewDidLoad() {
            super.viewDidLoad()

            // Setup the picker view
            productCategoryPickerView.delegate = self
            productCategoryPickerView.dataSource = self

            // Setup the stepper
            productQuantityStepper.minimumValue = 0
            productQuantityStepper.maximumValue = 100
            productQuantityStepper.stepValue = 1
            productQuantityStepper.addTarget(self, action: #selector(quantityChanged), for: .valueChanged)

            // If editing an existing product, populate the form with the existing product details
            if let existingProduct = product {
                populateProductDetails(product: existingProduct)
            }
        }

        // MARK: - UIPickerView Delegate & DataSource

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return categories.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return categories[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // Save the selected category
            if var currentProduct = product {
                currentProduct.category = categories[row]
                product = currentProduct
            }

            //product?.category = categories[row]
        }
        
        
        
        
        // MARK: - Select Image
        @IBAction func pPic(_ sender: Any) {
            showImageAlert()
        }

        private func showImageAlert() {
            let alert = UIAlertController(title: "Take Photo From", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                self.getPhoto(type: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }

//        @IBAction func pPic(_ sender: Any) {
//            showImageAlert()
//        }
//        
//        private func showImageAlert() {
//            let alert = UIAlertController(title: "Take Photo From", message: nil, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
//                self.getPhoto(type: .photoLibrary)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            present(alert, animated: true, completion: nil)
//        }
        
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
        
//
//        // MARK: - UIImagePickerController Delegate
//
//        @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
//            // Show photo library to select an image
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.delegate = self
//            imagePickerController.sourceType = .photoLibrary
//            present(imagePickerController, animated: true, completion: nil)
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                productImageView.image = selectedImage
//                product?.image = selectedImage
//            }
//            dismiss(animated: true, completion: nil)
//        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            switch textField {
            case productNameTextField:
                product?.name = textField.text ?? ""
            case productDescriptionTextField:
                product?.description = textField.text ?? ""
            case productPriceTextField:
                product?.price = Double(textField.text ?? "") ?? 0
            case productCO2TextField:
                product?.co2 = Double(textField.text ?? "") ?? 0
            case productPlasticTextField:
                product?.plasticWaste = Double(textField.text ?? "") ?? 0
            case productWaterTextField:
                product?.waterSaved = Double(textField.text ?? "") ?? 0
            case productQuantityTextField:
                product?.quantity = Int(textField.text ?? "") ?? 0
            default:
                break
            }
        }


//        // MARK: - UITextField Delegate Methods
//
//        @IBAction func productNameChanged(_ sender: UITextField) {
//            product?.name = sender.text ?? ""
//        }
//
//        @IBAction func productDescriptionChanged(_ sender: UITextField) {
//            product?.description = sender.text ?? ""
//        }
//
//        @IBAction func productPriceChanged(_ sender: UITextField) {
//            if let price = Double(sender.text ?? "") {
//                product?.price = price
//            }
//        }
//
//        @IBAction func productCO2Changed(_ sender: UITextField) {
//            if let co2 = Double(sender.text ?? "") {
//                product?.co2 = co2
//            }
//        }
//
//        @IBAction func productPlasticChanged(_ sender: UITextField) {
//            if let plastic = Double(sender.text ?? "") {
//                product?.plasticWaste = plastic
//            }
//        }
//
//        @IBAction func productWaterChanged(_ sender: UITextField) {
//            if let water = Double(sender.text ?? "") {
//                product?.waterSaved = water
//            }
//        }
//        @IBAction func productQuantityChanged(_ sender: UITextField) {
//            if let quantity = Int(sender.text ?? "") {
//                product?.quantity = quantity
//            }
//        }
//
        // Stepper action to adjust the quantity
        @objc func quantityChanged() {
            productQuantityTextField.text = "\(Int(productQuantityStepper.value))"
            product?.quantity = Int(productQuantityStepper.value)
        }

        // MARK: - Helper Methods

        func populateProductDetails(product: Product) {
            productNameTextField.text = product.name
            productDescriptionTextField.text = product.description
            productPriceTextField.text = "\(product.price)"
            productCO2TextField.text = "\(product.co2)"
            productPlasticTextField.text = "\(product.plasticWaste)"
            productWaterTextField.text = "\(product.waterSaved)"
            productQuantityTextField.text = "\(product.quantity)"
            productQuantityStepper.value = Double(product.quantity)

            if let image = product.image {
                productImageView.image = image
            }

            if let categoryIndex = categories.firstIndex(of: product.category) {
                productCategoryPickerView.selectRow(categoryIndex, inComponent: 0, animated: false)
            }
        }
        
        //@IBAction func saveProductDetails(_ sender: UIBarButtonItem) {
        
        @IBAction func saveProductDetails(_ sender: UIBarButtonItem) {
                // Validate all fields
                guard let name = productNameTextField.text, !name.isEmpty,
                      let description = productDescriptionTextField.text, !description.isEmpty,
                      let priceText = productPriceTextField.text, !priceText.isEmpty, let price = Double(priceText),
                      let co2Text = productCO2TextField.text, !co2Text.isEmpty, let co2 = Double(co2Text),
                      let plasticText = productPlasticTextField.text, !plasticText.isEmpty, let plasticWaste = Double(plasticText),
                      let waterText = productWaterTextField.text, !waterText.isEmpty, let waterSaved = Double(waterText),
                      let quantityText = productQuantityTextField.text, !quantityText.isEmpty, let quantity = Int(quantityText),
                      productCategoryPickerView.selectedRow(inComponent: 0) != -1 else {
                    // Show alert if validation fails
                    let alert = UIAlertController(title: AlertMessages.validationErrorTitle,
                                                  message: AlertMessages.validationErrorMessage,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true)
                    return
                }

                // Save the product details
                let selectedCategory = categories[productCategoryPickerView.selectedRow(inComponent: 0)]

                let updatedProduct = Product(
                    name: name,
                    description: description,
                    category: selectedCategory,
                    price: price,
                    co2: co2,
                    plasticWaste: plasticWaste,
                    waterSaved: waterSaved,
                    quantity: quantity,
                    image: productImageView.image
                )
                
                if product != nil {
                    // Update the existing product
                    product?.name = updatedProduct.name
                    product?.description = updatedProduct.description
                    product?.category = updatedProduct.category
                    product?.price = updatedProduct.price
                    product?.co2 = updatedProduct.co2
                    product?.plasticWaste = updatedProduct.plasticWaste
                    product?.waterSaved = updatedProduct.waterSaved
                    product?.quantity = updatedProduct.quantity
                    product?.image = updatedProduct.image
                    
                    // Show success alert for update
                    let successAlert = UIAlertController(title: AlertMessages.successUpdateTitle,
                                                         message: AlertMessages.successUpdateMessage,
                                                         preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Navigate back to the previous view controller
                        self.navigationController?.popViewController(animated: true)
                    }))
                    present(successAlert, animated: true)
                } else {
                    // Save as a new product
                    product = updatedProduct
                    
                    // Show success alert for creation
                    let successAlert = UIAlertController(title: AlertMessages.successCreateTitle,
                                                         message: AlertMessages.successCreateMessage,
                                                         preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Navigate back to the previous view controller
                        self.navigationController?.popViewController(animated: true)
                    }))
                    present(successAlert, animated: true)
                }
            }

//        // Validate all fields
//            guard let name = productNameTextField.text, !name.isEmpty,
//                  let description = productDescriptionTextField.text, !description.isEmpty,
//                  let priceText = productPriceTextField.text, !priceText.isEmpty, let price = Double(priceText),
//                  let co2Text = productCO2TextField.text, !co2Text.isEmpty, let co2 = Double(co2Text),
//                  let plasticText = productPlasticTextField.text, !plasticText.isEmpty, let plasticWaste = Double(plasticText),
//                  let waterText = productWaterTextField.text, !waterText.isEmpty, let waterSaved = Double(waterText),
//                  let quantityText = productQuantityTextField.text, !quantityText.isEmpty, let quantity = Int(quantityText),
//                  productCategoryPickerView.selectedRow(inComponent: 0) != -1 else {
//                // Show alert if validation fails
//                let alert = UIAlertController(title: AlertMessages.validationErrorTitle,
//                                              message: AlertMessages.validationErrorMessage,
//                                              preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                present(alert, animated: true)
//                return
//            }
//
//            // Save the product details
//            let selectedCategory = categories[productCategoryPickerView.selectedRow(inComponent: 0)]
//
//            let updatedProduct = Product(
//                name: name,
//                description: description,
//                category: selectedCategory,
//                price: price,
//                co2: co2,
//                plasticWaste: plasticWaste,
//                waterSaved: waterSaved,
//                quantity: quantity,
//                image: productImageView.image
//            )
//            
//            if product != nil {
//                // Update the existing product
//                product?.name = updatedProduct.name
//                product?.description = updatedProduct.description
//                product?.category = updatedProduct.category
//                product?.price = updatedProduct.price
//                product?.co2 = updatedProduct.co2
//                product?.plasticWaste = updatedProduct.plasticWaste
//                product?.waterSaved = updatedProduct.waterSaved
//                product?.quantity = updatedProduct.quantity
//                product?.image = updatedProduct.image
//                
//                // Show success alert for update
//                let successAlert = UIAlertController(title: AlertMessages.successUpdateTitle,
//                                                     message: AlertMessages.successUpdateMessage,
//                                                     preferredStyle: .alert)
//                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
//                present(successAlert, animated: true)
//            } else {
//                // Save as a new product
//                product = updatedProduct
//                
//                // Show success alert for creation
//                let successAlert = UIAlertController(title: AlertMessages.successCreateTitle,
//                                                     message: AlertMessages.successCreateMessage,
//                                                     preferredStyle: .alert)
//                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
//                present(successAlert, animated: true)
//            }
//        }

        
//        @IBAction func saveProductDetails(_ sender: UIBarButtonItem) {
//            // Validate all fields
//            guard let name = productNameTextField.text, !name.isEmpty,
//                  let description = productDescriptionTextField.text, !description.isEmpty,
//                  let priceText = productPriceTextField.text, !priceText.isEmpty, let price = Double(priceText),
//                  let co2Text = productCO2TextField.text, !co2Text.isEmpty, let co2 = Double(co2Text),
//                  let plasticText = productPlasticTextField.text, !plasticText.isEmpty, let plasticWaste = Double(plasticText),
//                  let waterText = productWaterTextField.text, !waterText.isEmpty, let waterSaved = Double(waterText),
//                  let quantityText = productQuantityTextField.text, !quantityText.isEmpty, let quantity = Int(quantityText),
//                  productCategoryPickerView.selectedRow(inComponent: 0) != -1 else {
//                
//                // Show alert if validation fails
//                let alert = UIAlertController(title: AlertMessages.validationErrorTitle,
//                                              message: AlertMessages.validationErrorMessage,
//                                              preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                present(alert, animated: true)
//                return
//            }
//            
//            // Save the product details
//            let selectedCategory = categories[productCategoryPickerView.selectedRow(inComponent: 0)]
//            guard productCategoryPickerView.selectedRow(inComponent: 0) != -1 else {
//                let alert = UIAlertController(title: AlertMessages.validationErrorTitle,
//                                              message: "Please select a category.",
//                                              preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                present(alert, animated: true)
//                return
//            }
//            let updatedProduct = Product(
//                name: name,
//                description: description,
//                category: selectedCategory,
//                price: price,
//                co2: co2,
//                plasticWaste: plasticWaste,
//                waterSaved: waterSaved,
//                quantity: quantity,
//                image: productImageView.image
//            )
//            
//            if product != nil {
//                // Update the existing product
//                product?.name = updatedProduct.name
//                product?.description = updatedProduct.description
//                product?.category = updatedProduct.category
//                product?.price = updatedProduct.price
//                product?.co2 = updatedProduct.co2
//                product?.plasticWaste = updatedProduct.plasticWaste
//                product?.waterSaved = updatedProduct.waterSaved
//                product?.quantity = updatedProduct.quantity
//                product?.image = updatedProduct.image
//                
//                // Show success alert for update
//                let successAlert = UIAlertController(title: "Updated",
//                                                     message: "Product details have been updated successfully!",
//                                                     preferredStyle: .alert)
//                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
//                present(successAlert, animated: true)
//            } else {
//                // Save as a new product
//                product = updatedProduct
//                
//                // Show success alert for creation
//                let successAlert = UIAlertController(title: "Created",
//                                                     message: "New product has been added successfully!",
//                                                     preferredStyle: .alert)
//                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
//                present(successAlert, animated: true)
//            }
//        }
//

//        // Save or Submit Product Details (Optional)
//        @IBAction func saveProductDetails(_ sender: UIButton) {
//            // Perform actions to save or submit the product details
//            // For example, you can save the product to a database or display it in a list
//            if let product = product {
//                print("Product saved: \(product)")
//            }
//        }
    }
