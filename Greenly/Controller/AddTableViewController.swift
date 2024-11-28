//
//  AddTableViewController.swift
//  tt
//
//  Created by BP-36-201-16N on 27/11/2024.
//

import UIKit

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Properties
    var details: Details?
    
    struct Details {
        var name: String = ""
        var email: String = ""
        var num: String = ""
        var pass: String = ""
        var location: String = ""
        var web: String = ""
        var from: String = ""
        var to: String = ""
    }
    
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
        //setupGestureForLogo()
    }
    
    // MARK: - Setup UI
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
        } else {
            title = "Add New Store"
        }
    }
    
//    // MARK: - Gesture Setup for Logo
//    private func setupGestureForLogo() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageTapped))
//        StoreLogo.addGestureRecognizer(tapGesture)
//        StoreLogo.isUserInteractionEnabled = true
//    }
    
    // MARK: - Select Image
   // @objc private func selectImageTapped() {
     //   let imagePicker = UIImagePickerController()
       // imagePicker.delegate = self
       // imagePicker.sourceType = .photoLibrary
       // present(imagePicker, animated: true, completion: nil)
   // }
    
    @IBAction func Logo(_ sender: Any) {
        //showImageAlert()
    }
    
//    var arrPhots = [UIImage]()
//    // MARK: - Select Image
//        func showImageAlert() {
//            let alert = UIAlertController(title: "Take Photo From", message: nil, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
//                self.getPhoto(type: .camera)
//            }))
//            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {action in
//                self.getPhoto(type: .photoLibrary)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            present(alert, animated: true, completion: nil)
//    }
//
//    func getPhoto(type: UIImagePickerController.SourceType){
//        let picker = UIImagePickerController()
//        picker.sourceType = type
//        picker.allowsEditing = false
//        picker.delegate = self
//        present(picker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
//        if let image = info[.originalImage] as? UIImage{
//            StoreLogo.image = image
//        }else{
//            print("image not found")
//        }
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
//            dismiss(animated: true, completion: nil)
//
//        }
//    }

    
    // MARK: - Save Button Action
    @IBAction func SaveAdded(_ sender: UIBarButtonItem) {
        let name = StoreName.text ?? ""
        let email = StoreEmail.text ?? ""
        let num = StoreNumber.text ?? ""
        let pass = StorePassword.text ?? ""
        let location = StoreLocation.text ?? ""
        let web = StoreWebsite.text ?? ""
        let from = StoreFrom.text ?? ""
        let to = StoreTo.text ?? ""
        
        if name.isEmpty || email.isEmpty || num.isEmpty || pass.isEmpty || location.isEmpty || web.isEmpty || from.isEmpty || to.isEmpty {
            AlertHelper.showAlert(on: self, title: "Error", message: "Please fill in all fields.")
            return
        }
        
        let updatedDetails = Details(name: name, email: email, num: num, pass: pass, location: location, web: web, from: from, to: to)
        
        if details == nil {
            print("Adding new details: \(updatedDetails)")
        } else {
            print("Editing existing details: \(updatedDetails)")
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
//extension AddTableViewController {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            StoreLogo.image = selectedImage
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}


// MARK: - Alert Helper
class AlertHelper {
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
