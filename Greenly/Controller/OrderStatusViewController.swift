//
//  OrderStatusViewController.swift
//  Greenly
//
//  Created by BP-36-208-T on 26/12/2024.
//

//import UIKit
//
//class OrderStatusViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//
//    var products: [CartProduct]?
//    var totalPrice = 0.0
//    var orderItems: [OrderItem]?
//
//    var order: Order? {
//        didSet {
//            self.orderItems = order?.items
//            self.totalPrice = order?.price ?? 0.0
//        }
//    }
//
//    let paymentMethodTitle = "Payment Method"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Initialize order data
//        order = Order(
//            id: "1004",
//            status: .delivering,
//            date: "24-12-2024",
//            price: 95.67,
//            ownerName: "Rocky",
//            feedback: "All Good",
//            rating: 4,
//            storeName: "Earth Hero",
//            items: [
//                OrderItem(name: "bla", price: "9.00", quantity: "7"),
//                OrderItem(name: "Reusable Coffee Cup", price: "12.00", quantity: "1"),
//                OrderItem(name: "Eco-Friendly Straw", price: "5.00", quantity: "2"),
//                OrderItem(name: "Organic Tote Bag", price: "20.00", quantity: "1"),
//                OrderItem(name: "bla", price: "9.00", quantity: "7"),
//                OrderItem(name: "bla", price: "9.00", quantity: "7"),
//                OrderItem(name: "bla", price: "9.00", quantity: "7"),
//                OrderItem(name: "bla", price: "9.00", quantity: "7"),
//                OrderItem(name: "bla", price: "9.00", quantity: "7")
//            ],
//            paymentMethod: "Credit/Debit Card"
//        )
//
//        registerCells()
//        setupTableView()
//        tableView.reloadData()
//    }
//
//    func registerCells() {
//        tableView.register(UINib(nibName: "subTitleCell", bundle: .main), forCellReuseIdentifier: "subTitleCell")
//        tableView.register(UINib(nibName: "TrackerCell", bundle: .main), forCellReuseIdentifier: "TrackerCell")
//        tableView.register(UINib(nibName: "MyOrderCell", bundle: .main), forCellReuseIdentifier: "MyOrderCell")
//        tableView.register(UINib(nibName: "TotalAmountCell", bundle: .main), forCellReuseIdentifier: "TotalAmountCell")
//    }
//
//    func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//}
//
//// MARK: - UITableViewDelegate and UITableViewDataSource
//extension OrderStatusViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 2: // MyOrderCell section
//            return 1 // Only one cell for the entire list of items
//        default:
//            return 1
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "subTitleCell", for: indexPath) as! subTitleCell
//            cell.title.text = order?.storeName ?? ""
//            cell.orderId.text = "Order #: \(order?.id ?? "N/A")" // Updated to display "Order #: (id)"
//            return cell
//
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
//            configureTrackerCell(cell)
//            return cell
//
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
//            cell.titleLabel.text = "My Order"
//            cell.configure(orderItems: orderItems ?? []) // Pass all order items
//            return cell
//
//
//
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
//            cell.titleLabel.text = paymentMethodTitle
//            cell.ItemName.text = order?.paymentMethod ?? "Not Available"
//            cell.Price.text = ""
//            cell.Quantity.text = ""
//            return cell
//
//        case 4:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalAmountCell", for: indexPath) as! TotalAmountCell
//            cell.TotalTitleLabel.text = "Total Amount"
//            cell.totalPriceLabel.text = String(format: "%.2f BD", totalPrice)
//            return cell
//
//        default:
//            return UITableViewCell()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.0001
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.0001
//    }
//
//    func configureTrackerCell(_ cell: TrackerCell) {
//        cell.circle1.image = UIImage(systemName: "circle")
//        cell.circle2.image = UIImage(systemName: "circle")
//        cell.circle3.image = UIImage(systemName: "circle")
//
//        cell.Pending.textColor = .black
//        cell.Out.textColor = .black
//        cell.Delivered.textColor = .black
//
//        switch order?.status {
//        case .pending:
//            cell.circle1.image = UIImage(systemName: "checkmark.circle.fill")
//        case .delivering:
//            cell.circle1.image = UIImage(systemName: "checkmark.circle.fill")
//            cell.circle2.image = UIImage(systemName: "checkmark.circle.fill")
//        case .delivered:
//            cell.circle1.image = UIImage(systemName: "checkmark.circle.fill")
//            cell.circle2.image = UIImage(systemName: "checkmark.circle.fill")
//            cell.circle3.image = UIImage(systemName: "checkmark.circle.fill")
//        default:
//            break
//        }
//    }
//}

import UIKit

class OrderStatusViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var addFeedbackBtnOutlet: UIButton!
    
    var order: Order? {
        didSet {
            self.orderItems = order?.items
            self.totalPrice = order?.price ?? 0.0
        }
    }

    var orderItems: [OrderItem]?
    var totalPrice: Double = 0.0

    let paymentMethodTitle = "Payment Method"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerCells()
        updateUI()
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func registerCells() {
        tableView.register(UINib(nibName: "subTitleCell", bundle: .main), forCellReuseIdentifier: "subTitleCell")
        tableView.register(UINib(nibName: "TrackerCell", bundle: .main), forCellReuseIdentifier: "TrackerCell")
        tableView.register(UINib(nibName: "MyOrderCell", bundle: .main), forCellReuseIdentifier: "MyOrderCell")
        tableView.register(UINib(nibName: "TotalAmountCell", bundle: .main), forCellReuseIdentifier: "TotalAmountCell")
    }

    private func updateUI() {
        guard order != nil else { return }
        title = "Order Status"
        // Show or hide the feedback button based on the order's status
        addFeedbackBtnOutlet.isHidden = order?.status != .delivered
    }
    @IBAction func addFeedBackBtnPressed(_ sender: UIButton) {
        // Present FeedbackViewController for customer to add feedback
             guard let order = order else { return }

             let feedbackVC = UIStoryboard(name: "StoreOwner", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
             feedbackVC.order = order
             feedbackVC.delegate = self

             feedbackVC.modalPresentationStyle = .overCurrentContext
             feedbackVC.modalTransitionStyle = .crossDissolve
             present(feedbackVC, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension OrderStatusViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subTitleCell", for: indexPath) as! subTitleCell
            cell.title.text = order?.storeName ?? ""
            cell.orderId.text = "Order #: \(order?.id ?? "N/A")"
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
            configureTrackerCell(cell)
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
            cell.titleLabel.text = "My Order"
            cell.configure(orderItems: orderItems ?? [])
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
            cell.titleLabel.text = paymentMethodTitle
            cell.ItemName.text = order?.paymentMethod ?? "Not Available"
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalAmountCell", for: indexPath) as! TotalAmountCell
            cell.TotalTitleLabel.text = "Total Amount"
            cell.totalPriceLabel.text = String(format: "%.2f BD", totalPrice)
            
//            // Add "Leave Feedback" button for delivered status
//            if let status = order?.status, status == .delivered {
//                let feedbackButton = UIButton(type: .system)
//                feedbackButton.setTitle("Leave Feedback", for: .normal)
//                feedbackButton.addTarget(self, action: #selector(feedbackButtonTapped), for: .touchUpInside)
//                cell.contentView.addSubview(feedbackButton)
//            }

            return cell

        default:
            return UITableViewCell()
        }
    }

    private func configureTrackerCell(_ cell: TrackerCell) {
        cell.circle1.image = UIImage(systemName: "circle")
        cell.circle2.image = UIImage(systemName: "circle")
        cell.circle3.image = UIImage(systemName: "circle")

        cell.Pending.textColor = .black
        cell.Out.textColor = .black
        cell.Delivered.textColor = .black

        switch order?.status {
        case .pending:
            cell.circle1.image = UIImage(systemName: "checkmark.circle.fill")
        case .delivering:
            cell.circle1.image = UIImage(systemName: "checkmark.circle.fill")
            cell.circle2.image = UIImage(systemName: "checkmark.circle.fill")
        case .delivered:
            cell.circle1.image = UIImage(systemName: "checkmark.circle.fill")
            cell.circle2.image = UIImage(systemName: "checkmark.circle.fill")
            cell.circle3.image = UIImage(systemName: "checkmark.circle.fill")
        default:
            break
        }
    }
    
    @objc func feedbackButtonTapped() {
          guard let order = self.order else { return }
          
          let feedbackFormVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
          feedbackFormVC.order = order
          navigationController?.pushViewController(feedbackFormVC, animated: true)
      }
}

extension OrderStatusViewController: FeedbackDelegate {
    func didSubmitFeedback(for order: Order) {
        self.order = order
        updateUI()
    }

    func didDeleteFeedback(for order: Order) {
        self.order?.feedback = nil
        self.order?.rating = 0
        updateUI()
    }
}
