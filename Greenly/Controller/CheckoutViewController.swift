//
//  CheckoutViewController.swift
//  MyProject
//
//  Created on 13/12/24.
//

import UIKit

class CheckoutViewController: UIViewController {
   
    enum PaymentMethod: String {
        case cash
        case card
        case none
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    var totalPrice = 0.0
    var products: [CartProduct]?
    var selectedPaymentType: PaymentMethod = .none
    
    var selectedAddress = [String: String]()

    var savedAddresses = [[String: String]]() {
        didSet {
            if savedAddresses.count == 1 {
                self.selectedAddress = savedAddresses[0]
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.register()
        tableview.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let allAddresses = UserDefaults.standard.array(forKey: "savedAddresses") as? [[String: String]] {
            savedAddresses.removeAll()
            savedAddresses.append(contentsOf: allAddresses)
            tableview.reloadData()
        }
    }
    func register() {
        tableview.register(UINib(nibName: "CheckoutTableViewCell", bundle: .main), forCellReuseIdentifier: "CheckoutTableViewCell")
        tableview.register(UINib(nibName: "CheckoutCell", bundle: .main), forCellReuseIdentifier: "CheckoutCell")
        tableview.register(UINib(nibName: "ProductDescriptionCell", bundle: .main), forCellReuseIdentifier: "productDescriptionCell")
        tableview.register(UINib(nibName: "SubCell", bundle: .main), forCellReuseIdentifier: "SubCell")
        tableview.register(UINib(nibName: "SavedAddressCell", bundle: .main), forCellReuseIdentifier: "savedAddressCell")
    }
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return savedAddresses.count + 2 // Add row for saved address if available
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return createTitleCell(tableView, cellForRowAt: indexPath, title: "Saved Addresses")
            } else if tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
                cell.cellBackgroundView.cornerRadius = 4
                cell.titleLabel.text = "Add New Address"
                cell.leftButton.setImage(UIImage(systemName: "plus"), for: .normal)
                cell.leftButtonTapped = {
                    self.performSegue(withIdentifier: "addressNav", sender: nil)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "savedAddressCell", for: indexPath) as! SavedAddressCell
                cell.cellBackgroundView.cornerRadius = 4
                //set the address
//                let address = [
//                    "name": addressDetails[0],
//                    "area": addressDetails[1],
//                    "buildingNumber": addressDetails[2],
//                    "roadNumber": addressDetails[3],
//                    "blockNumber": addressDetails[4]
//                ]
                let address = savedAddresses[indexPath.row - 1]
                cell.AddNameLabel.text = address["name"]
                cell.areaLabel.text = address["area"]
                cell.buildLabel.text = address["buildingNumber"]
                cell.roadLabel.text = address["roadNumber"]
                cell.blockLabel.text = address["blockNumber"]
                cell.cellAddress = address
                if address["name"] == selectedAddress["name"] {
                    cell.isChecked = true
                } else {
                    cell.isChecked = false
                }
                
                cell.onCheckboxToggle = { status in
                    if status {
                        self.selectedAddress = cell.cellAddress
                    } else {
                        self.selectedAddress = [:]
                    }
                    self.tableview.reloadData()
                }
                
                cell.onDelete = {
                    if let index = self.savedAddresses.firstIndex(of: cell.cellAddress) {
                        self.savedAddresses.remove(at: index)
                        UserDefaults.standard.removeObject(forKey: "savedAddress")
                        self.tableview.reloadData()
                    }
                }
                return cell
            }
        case 1:
            return createPaymentMethodSection(tableView, cellForRowAt: indexPath)
        case 2:
            if indexPath.row == 0 {
                return createTitleCell(tableView, cellForRowAt: indexPath, title: "Order Summery")
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath) as! SubCell
                cell.cellBackgroundView.cornerRadius = 4
//                let productCount = products?.count ?? 0
                let productCount = products?.reduce(0, { partialResult, product in
                    return partialResult + (product.quantity ?? 1)
                })
                cell.checkButton.isHidden = true
                cell.titleLabel.text = "(\(String(describing: productCount ?? 1))) Items"
                cell.totalPriceLabel.text = "Total :  \(totalPrice) BD"
                cell.cellBackgroundView.backgroundColor = .white
                cell.contentView.backgroundColor = .clear
                cell.cellBackgroundViewLeadingConstraint.constant = 32
                cell.cellBackgroundViewTrailingConstraint.constant = 32
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell
            cell.CheckoutButton.layer.cornerRadius = 10
            cell.CheckoutButton.layer.borderWidth = 1
            let buttonTitle = selectedPaymentType == .card ? "Confirm & Pay" : "Place Order"
            cell.CheckoutButton.setTitle(buttonTitle, for: .normal)
            cell.CheckoutButton.isEnabled = (selectedPaymentType != .none) && !selectedAddress.isEmpty
            cell.checkOutButtonTapped = {
//                self.performSegue(withIdentifier: "checkOutNav", sender: nil)
            }
            return cell
        
        default:
            return UITableViewCell()
        }
    }
    
    func createTitleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, title: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productDescriptionCell", for: indexPath) as! ProductDescriptionCell
        cell.titleLabel.text = title
        cell.descriptionLabel.text = ""
        cell.titleLableLeadingConstraint.constant = 29
        return cell
    }
    
    func createPaymentMethodSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return createTitleCell(tableView, cellForRowAt: indexPath, title: "Payment Method")
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
            cell.cellBackgroundView.cornerRadius = 4
            cell.titleLabel.text = "Cash on Delivery"
            
            cell.isChecked = self.selectedPaymentType == .cash
            let imageForButton = cell.isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
            cell.leftButton.setImage(imageForButton, for: .normal)
            
            cell.leftButtonTapped = {
                cell.isChecked.toggle()
                self.selectedPaymentType = cell.isChecked ? .cash : .none
                self.tableview.reloadRows(at: [IndexPath(row: 2, section: indexPath.section), IndexPath(row: 0, section: 3)], with: .automatic)
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
            cell.cellBackgroundView.cornerRadius = 4
            cell.titleLabel.text = "Credit/Debit Card"
            
            cell.isChecked = self.selectedPaymentType == .card
            let imageForButton = cell.isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
            cell.leftButton.setImage(imageForButton, for: .normal)
            
            cell.leftButtonTapped = {
                cell.isChecked.toggle()
                self.selectedPaymentType = cell.isChecked ? .card : .none
                self.tableview.reloadRows(at: [IndexPath(row: 1, section: indexPath.section), IndexPath(row: 0, section: 3)], with: .automatic)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Adjust as needed for your cell layout.
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00001
        }
        return 11
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}
