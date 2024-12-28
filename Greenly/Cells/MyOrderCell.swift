//
//  MyOrderCell.swift
//  testing
//
//  Created by BP-36-201-01 on 21/12/2024.
//

import UIKit

class MyOrderCell: UITableViewCell {

    @IBOutlet weak var ItemName: UILabel!
    
    @IBOutlet weak var Price: UILabel!
    
    @IBOutlet weak var Quantity: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var viewUI: UIView!
  
    override func awakeFromNib() {
            super.awakeFromNib()
            setupViewUI()
        }

        private func setupViewUI() {
            viewUI.layer.cornerRadius = 8
            viewUI.layer.masksToBounds = true
        }

    func configure(orderItems: [OrderItem]) {
        guard !orderItems.isEmpty else { return }

        // Clear all subviews in viewUI
        viewUI.subviews.forEach { $0.removeFromSuperview() }

        var lastView: UIView? = nil

        // Add each item dynamically
        for item in orderItems {
            let itemView = createItemView(for: item)
            viewUI.addSubview(itemView)

            // Add constraints for the itemView
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: viewUI.leadingAnchor, constant: 8),
                itemView.trailingAnchor.constraint(equalTo: viewUI.trailingAnchor, constant: -8),
                itemView.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? viewUI.topAnchor, constant: 8)
            ])

            // Update lastView
            lastView = itemView
        }

        // Ensure the last item anchors to the bottom
        if let lastView = lastView {
            NSLayoutConstraint.activate([
                lastView.bottomAnchor.constraint(equalTo: viewUI.bottomAnchor, constant: -8)
            ])
        }
    }

    private func createItemView(for item: OrderItem) -> UIView {
        let itemView = UIView()

        // Item Name Label
        let itemNameLabel = UILabel()
        itemNameLabel.text = item.name
        itemNameLabel.font = UIFont.systemFont(ofSize: 14)
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Price Label with Gray Number
        let priceLabel = UILabel()
        priceLabel.attributedText = createAttributedText(
            mainText: "Price: ",
            grayText: "\(item.price)"
        )
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        // Quantity Label with Gray Number
        let quantityLabel = UILabel()
        quantityLabel.attributedText = createAttributedText(
            mainText: "Quantity: ",
            grayText: "\(item.quantity)"
        )
        quantityLabel.font = UIFont.systemFont(ofSize: 12)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add labels to itemView
        itemView.addSubview(itemNameLabel)
        itemView.addSubview(priceLabel)
        itemView.addSubview(quantityLabel)

        // Constraints for labels
        NSLayoutConstraint.activate([
            // Item Name - Top Left
            itemNameLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
            itemNameLabel.topAnchor.constraint(equalTo: itemView.topAnchor),
            itemNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -8),

            // Price - Top Right
            priceLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: itemView.topAnchor),

            // Quantity - Below Price
            quantityLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            quantityLabel.bottomAnchor.constraint(equalTo: itemView.bottomAnchor)
        ])

        return itemView
    }

    private func createAttributedText(mainText: String, grayText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: mainText, attributes: [
            .foregroundColor: UIColor.black // Main text in black
        ])
        
        let grayAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray // Gray for numbers
        ]
        
        let grayPart = NSAttributedString(string: grayText, attributes: grayAttributes)
        attributedString.append(grayPart) // Append the gray text
        
        return attributedString
    }


    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }

    
}

