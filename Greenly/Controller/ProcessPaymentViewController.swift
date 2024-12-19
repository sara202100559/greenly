//
//  ProcessPaymentViewController.swift
//  MyProject
//
//  Created by BP-36-201-21 on 19/12/2024.
//


import UIKit

class ProcessPaymentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var paymentDetails: [String] = ["", "", ""] // Card Number, Expiration Date, CVV
       var validationStatus: [Bool] = [false, false, false] // Validation status for each field

       override func viewDidLoad() {
           super.viewDidLoad()
           registerCells()
       }
       
       func registerCells() {
           tableView.register(UINib(nibName: "InputTableViewCell", bundle: .main), forCellReuseIdentifier: "InputTableViewCell")
           tableView.register(UINib(nibName: "CheckoutCell", bundle: .main), forCellReuseIdentifier: "CheckoutCell")
       }
       
    func processPayment(completion: @escaping () -> Void) {
        let successAlert = UIAlertController(
            title: "Payment Successful!",
            message: "Thank you for your payment.",
            preferredStyle: .alert
        )
        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Invoke the completion handler after the alert is dismissed
            completion()
        }))
        
        self.present(successAlert, animated: true, completion: nil)
    }
    
    func processOrder() {
        let alert = UIAlertController(
            title: "Order Placed",
            message: "Your order has been placed successfully!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Navigate back to the main screen or reset the cart if needed
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

   }

   extension ProcessPaymentViewController: UITableViewDelegate, UITableViewDataSource {
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return 2
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return section == 0 ? 3 : 1
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if indexPath.section == 0 {
               let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as! InputTableViewCell
               cell.inputTextField.tag = indexPath.row
               switch indexPath.row {
               case 0:
                   cell.inputTextField.placeholder = "Card Number (16 digits)"
                   cell.inputTextField.keyboardType = .numberPad
               case 1:
                   cell.inputTextField.placeholder = "Expiration Date (MM-YY)"
                   cell.inputTextField.keyboardType = .numbersAndPunctuation
               case 2:
                   cell.inputTextField.placeholder = "CVV (3 digits)"
                   cell.inputTextField.keyboardType = .numberPad
               default:
                   break
               }
               cell.inputTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
               return cell
           } else {
               let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell
               cell.CheckoutButton.layer.cornerRadius = 10
               cell.CheckoutButton.layer.borderWidth = 1
               cell.CheckoutButton.setTitle("Pay Now", for: .normal)
               
               // Enable the button only if all fields are valid
               cell.CheckoutButton.isEnabled = validationStatus.allSatisfy { $0 }
               
               cell.checkOutButtonTapped = { [weak self] in
                   guard let self = self else { return }

                   // Only proceed if all validation conditions are met
                   if self.validationStatus.allSatisfy({ $0 }) {
                       // Pass the completion closure to processPayment
                       self.processPayment(completion: {
                           self.processOrder()
                       })
                   }
               }




               return cell

           }
       }
       
       // Real-time validation of input fields
       @objc func textFieldChanged(_ sender: UITextField) {
           guard let text = sender.text else { return }
           let index = sender.tag
           
           // Validate fields based on their index
           switch index {
           case 0: // Card Number
               validationStatus[index] = text.count == 16 && text.allSatisfy { $0.isNumber }
           case 1: // Expiration Date
               let components = text.split(separator: "-")
               if components.count == 2,
                  components[0].count == 2, components[1].count == 2, // Ensure strict MM-YY format
                  let month = Int(components[0]), let year = Int(components[1]),
                  month >= 1 && month <= 12 && year > 24 {
                   validationStatus[index] = true
               } else {
                   validationStatus[index] = false
               }
           case 2: // CVV
               validationStatus[index] = text.count == 3 && text.allSatisfy { $0.isNumber }
           default:
               break
           }
           
           // Update payment details array
           if index < paymentDetails.count {
               paymentDetails[index] = text
           }
           
           // Reload the checkout section to update the button state
           let checkoutIndexPath = IndexPath(row: 0, section: 1)
           tableView.reloadRows(at: [checkoutIndexPath], with: .none)
       }
       
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           return UIView()
       }
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return section == 0 ? 0.00001 : 11
       }
   }
