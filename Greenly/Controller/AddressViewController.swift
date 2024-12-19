import UIKit

 

class AddressViewController: UIViewController {

     

    @IBOutlet weak var tableView: UITableView!

     

    var addressDetails: [String] = ["", "", "", "", ""] // To store input values

    var validationStatus: [Bool] = [false, false, false, false, false] // Tracks if each field is valid

     

    override func viewDidLoad() {

        super.viewDidLoad()

        register()

        loadSavedAddress() // Load saved address data if available

    }

     

    func register() {

        tableView.register(UINib(nibName: "InputTableViewCell", bundle: .main), forCellReuseIdentifier: "InputTableViewCell")

        tableView.register(UINib(nibName: "CheckoutCell", bundle: .main), forCellReuseIdentifier: "CheckoutCell")

    }

     

    // Function to save address to UserDefaults

    func saveAddress() {
        var allAdress = [[String: String]]()
        if let addresses = UserDefaults.standard.array(forKey: "savedAddresses") as? [[String: String]] {
            allAdress.append(contentsOf: addresses)
        }
        let address = [
            "name": addressDetails[0],
            "area": addressDetails[1],
            "buildingNumber": addressDetails[2],
            "roadNumber": addressDetails[3],
            "blockNumber": addressDetails[4]
        ]
        allAdress.append(address)
        UserDefaults.standard.set(allAdress, forKey: "savedAddresses")
        
        NotificationCenter.default.post(name: Notification.Name("AddressSaved"), object: address)
        self.navigationController?.popViewController(animated: true)
    }


     

    // Load saved address if exists

    func loadSavedAddress() {

        if let savedAddress = UserDefaults.standard.dictionary(forKey: "savedAddress") as? [String: String] {

            addressDetails[0] = savedAddress["name"] ?? ""

            addressDetails[1] = savedAddress["area"] ?? ""

            addressDetails[2] = savedAddress["buildingNumber"] ?? ""

            addressDetails[3] = savedAddress["roadNumber"] ?? ""

            addressDetails[4] = savedAddress["blockNumber"] ?? ""

             

            tableView.reloadData() // Reload data after loading saved address

        }

    }

     

    // Show an alert for incomplete or incorrect fields

    func showIncompleteFieldsAlert() {

        let alert = UIAlertController(title: "Incomplete or Invalid Address", message: "Please ensure all fields are filled correctly.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)

    }

}

 

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 2

    }

     

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return section == 0 ? 5 : 1

    }

     

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as! InputTableViewCell

            cell.inputTextField.tag = indexPath.row

            switch indexPath.row {

            case 0:

                cell.inputTextField.placeholder = "Address Name"

            case 1:

                cell.inputTextField.placeholder = "Area"

            case 2:

                cell.inputTextField.placeholder = "Building Number"

            case 3:

                cell.inputTextField.placeholder = "Road Number"

            case 4:

                cell.inputTextField.placeholder = "Block Number"

            default:

                break

            }

            cell.inputTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)

            return cell

        } else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell

            cell.CheckoutButton.layer.cornerRadius = 10

            cell.CheckoutButton.layer.borderWidth = 1

            cell.CheckoutButton.setTitle("Save Address", for: .normal)

             

            // Dynamically enable or disable the button based on validation status

            cell.CheckoutButton.isEnabled = validationStatus.allSatisfy { $0 }

             

            cell.checkOutButtonTapped = { [weak self] in

                guard let self = self else { return }

                if self.validationStatus.allSatisfy({ $0 }) {

                    self.saveAddress()

                    let alert = UIAlertController(title: "Success!", message: "Address has been saved!", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default))

                    self.present(alert, animated: true)

                } else {

                    self.showIncompleteFieldsAlert()

                }

            }

            return cell

        }

    }

     

    // Real-time validation of each field

    @objc func textFieldChanged(_ sender: UITextField) {

        guard let text = sender.text else { return }

        let index = sender.tag

         

        // Perform validation for each text field based on its index

        switch index {

        case 0, 1: // Address Name and Area

            validationStatus[index] = !text.isEmpty && text.count <= 25 // equale or less than 25 characters and not empty

        case 2, 3, 4: // Building, Road, and Block

            validationStatus[index] = !text.isEmpty && Int(text) != nil // Must be a valid integer and not empty

        default:

            break

        }

         

        // Update the corresponding value in `addressDetails`

        if index < addressDetails.count {

            addressDetails[index] = text

        }

         

        // Reload the checkout section to update button state

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
