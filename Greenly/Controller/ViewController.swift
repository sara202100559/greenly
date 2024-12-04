//
//  ViewController.swift
//  Greenly
//
//  Created by BP-36-201-20 on 26/11/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Cloudinary

class ViewController: UIViewController {
    
    @IBOutlet weak var ivUploadedImage: CLDUIImageView!
    @IBOutlet weak var ivGenerateUrl: CLDUIImageView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    let cloudName: String = "dlltooaqi"
    var uploadPreset: String = "unsigned_upload"
    var publicId: String = "cld-sample-5"
    
    var cloudinary: CLDCloudinary!
    var url: String!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        initCloudinary()
        uploadImage()
        generateUrl()
  
        
        
//        // Create a root reference
//        let storageRef = storage.reference()
//
//        // Create a reference to "mountains.jpg"
//        let mountainsRef = storageRef.child("mountains.jpg")
//
//        // Create a reference to 'images/mountains.jpg'
//        let mountainImagesRef = storageRef.child("images/mountains.jpg")
//
//        // While the file names are the same, the references point to different files
//        mountainsRef.name == mountainImagesRef.name            // true
//        mountainsRef.fullPath == mountainImagesRef.fullPath    // false
//            
//        // Data in memory
//        let data = Data()
//
//        // Create a reference to the file you want to upload
//        let riversRef = storageRef.child("images/rivers.jpg")
//
//        // Upload the file to the path "images/rivers.jpg"
//        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
//          guard let metadata = metadata else {
//            // Uh-oh, an error occurred!
//            return
//          }
//          // Metadata contains file metadata such as size, content-type.
//          let size = metadata.size
//          // You can also access to download URL after upload.
//          riversRef.downloadURL { (url, error) in
//            guard let downloadURL = url else {
//              // Uh-oh, an error occurred!
//              return
//            }
//          }
//        }
//            
        
        // Add a new document with a generated ID
//        do {
//          let ref =  db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "lajhst": "Lovelace",
//            "born": 1815
//          ])
//          print("Document added with ID: \(ref.documentID)")
//        } catch {
//          print("Error adding document: \(error)")
//        }
//        Auth.auth().createUser(withEmail: "sumaya@gmail.com", password: "Sumaya.123") { authResult, error in
//          // ...
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setImageView()
    }
    
    private func initCloudinary() {
        let config = CLDConfiguration(cloudName: cloudName, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }
    private func generateUrl() {
            url = cloudinary.createUrl().setTransformation(CLDTransformation().setEffect("sepia")).generate(publicId)
        }
    
    private func setImageView() {
            ivGenerateUrl.cldSetImage(url, cloudinary: cloudinary)
        }

    private func uploadImage() {
        guard let data = UIImage(named: "cloudinary_logo")?.pngData() else {
            return
        }
        
        cloudinary.createUploader().upload(data: data, uploadPreset: uploadPreset, completionHandler:  { response, error in
            DispatchQueue.main.async {
                guard let url = response?.secureUrl else {
                    return
                }
                self.ivUploadedImage.cldSetImage(url, cloudinary: self.cloudinary)
            }
        })
     }

}

