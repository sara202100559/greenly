////By Qamarain
////  ManualViewController.swift
////  tracker
//
//
//
//import UIKit
//
//class ManualViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    @IBOutlet var tableViewButton: UIButton!
//    @IBOutlet var tableView: UITableView!
//    @IBOutlet var transparentView: UIView!
//    @IBOutlet var optionsButton: UIButton!
//    @IBOutlet var tableView2: UITableView!
//    @IBOutlet var transparentView2: UIView!
//    @IBOutlet var productNameTextField: UITextField!
//    @IBOutlet var quantityTextField: UITextField!
//
//    var returnPhaseList: [String] = ["Personal Care Items", "Cleaning Supplies", "Kitchen Products", "Others"]
//    var options: [Item] = [
//        Item(title: "Plastic Waste Reduction Product", isSelected: false),
//        Item(title: "Water Conservation Product", isSelected: false),
//        Item(title: "Carbon Emission Reduction", isSelected: false),
//        Item(title: "Others", isSelected: false)
//    ]
//
//    struct Item {
//        let title: String
//        var isSelected: Bool
//    }
//
//    // Fixed impact values (example values)
//    let impactValues: [String: Double] = [
//        "Plastic Waste Reduction Product": 2.0, // kg saved per product
//        "Water Conservation Product": 1.5,      // kg CO2 equivalent saved per product
//        "Carbon Emission Reduction": 3.0,        // kg CO2 saved per product
//        "Others": 1.0                            // kg saved per product
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.isHidden = true
//        transparentView.isHidden = true
//
//        tableView2.delegate = self
//        tableView2.dataSource = self
//        tableView2.isHidden = true
//        transparentView2.isHidden = true
//
//        // Set keyboard type for the quantity text field
//        quantityTextField.keyboardType = .numberPad
//
//        // Add targets to restrict input
//        productNameTextField.addTarget(self, action: #selector(restrictProductNameInput), for: .editingChanged)
//        quantityTextField.addTarget(self, action: #selector(restrictQuantityInput), for: .editingChanged)
//    }
//
//    @IBAction func onShowTableViewButtonPressed(_ sender: UIButton) {
//        showTableView()
//    }
//
//    private func showTableView() {
//        tableView.isHidden = false
//        transparentView.isHidden = false
//    }
//
//    private func hideTableView() {
//        tableView.isHidden = true
//        transparentView.isHidden = true
//    }
//
//    @IBAction func onOptionsButtonPressed(_ sender: UIButton) {
//        showOptions()
//    }
//
//    private func showOptions() {
//        tableView2.isHidden = false
//        transparentView2.isHidden = false
//    }
//
//    private func hideOptions() {
//        tableView2.isHidden = true
//        transparentView2.isHidden = true
//    }
//
//    // UITableViewDataSource Methods for Main Table View
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableView == self.tableView ? returnPhaseList.count : options.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
//        if tableView == self.tableView {
//            cell.textLabel?.text = returnPhaseList[indexPath.row]
//        } else if tableView == tableView2 {
//            let item = options[indexPath.row]
//            cell.textLabel?.text = item.title
//            cell.accessoryType = item.isSelected ? .checkmark : .none
//        }
//        return cell
//    }
//
//    // UITableViewDelegate Method for Main Table View
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == self.tableView {
//            let selectedItem = returnPhaseList[indexPath.row]
//            tableViewButton.setTitle(selectedItem, for: .normal)
//            hideTableView()
//        } else if tableView == tableView2 {
//            options[indexPath.row].isSelected.toggle()
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//    }
//
//    // Dismiss dropdowns when tapping outside
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !transparentView.isHidden { hideTableView() }
//        if !transparentView2.isHidden { hideOptions() }
//        super.touchesBegan(touches, with: event)
//    }
//
//    // Validate and save the data
//    @IBAction func onSaveButtonPressed(_ sender: UIButton) {
//        guard let productName = productNameTextField.text, !productName.isEmpty else {
//            showAlert(message: "Please enter a product name.")
//            return
//        }
//
//        guard let quantityText = quantityTextField.text, let quantity = Int(quantityText), quantity > 0 else {
//            showAlert(message: "Please enter a valid quantity (numbers only).")
//            return
//        }
//
//        // Check if a category is selected
//        guard let selectedCategory = tableViewButton.title(for: .normal), !selectedCategory.isEmpty else {
//            showAlert(message: "Please select a category.")
//            return
//        }
//
//        // Check if at least one option is selected
//        let selectedOptions = options.filter { $0.isSelected }.map { $0.title }
//        guard !selectedOptions.isEmpty else {
//            showAlert(message: "Please select at least one option.")
//            return
//        }
//
//        // Calculate impact based on quantity
//        var totalImpact: Double = 0.0
//        for option in selectedOptions {
//            if let impactPerItem = impactValues[option] {
//                totalImpact += impactPerItem * Double(quantity)
//            }
//        }
//
//        // Update chart data
//            for option in selectedOptions {
//                ImpactData.shared.chartData[option, default: 0.0] += impactValues[option]! * Double(quantity)
//            }
//
//            // Refresh the chart
//            if let chartVC = self.navigationController?.viewControllers.compactMap({ $0 as? ChartViewController }).first {
//                chartVC.refreshChart()
//            }
//
//        // Show success alert
//        showAlert(message: "Data saved successfully!❤️")
//    }
//
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true)
//    }
//
//    // Restrict input to alphabetic characters only for product name
//    @objc private func restrictProductNameInput() {
//        let allowedCharacters = CharacterSet.letters
//        let filtered = productNameTextField.text?.unicodeScalars.filter { allowedCharacters.contains($0) }
//        productNameTextField.text = String(String.UnicodeScalarView(filtered!))
//    }
//
//    // Restrict input to numeric characters only for quantity
//    @objc private func restrictQuantityInput() {
//        let allowedCharacters = CharacterSet.decimalDigits
//        let filtered = quantityTextField.text?.unicodeScalars.filter { allowedCharacters.contains($0) }
//        quantityTextField.text = String(String.UnicodeScalarView(filtered!))
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
