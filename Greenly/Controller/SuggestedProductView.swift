//
//  SuggestedProductView.swift
//  Greenly
//

import UIKit

class SuggestedProductView: UIView {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var onProductTap: ((Product) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let nib = UINib(nibName: "SuggestedProductView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }

    func configure(with product: Product) {
        productNameLabel.text = product.name
        productPriceLabel.text = "$\(product.price)"
        if let urlString = product.imageUrl, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.productImageView.image = image
                    }
                }
            }
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        if let onProductTap = onProductTap {
            onProductTap(Product(
                name: productNameLabel.text ?? "",
                description: "",
                category: "",
                price: productPriceLabel.text?.replacingOccurrences(of: "$", with: "") ?? "",
                image: UIImage(),
                co2Emissions: "",
                plasticWaste: "",
                waterSaved: "",
                quantity: "",
                storeId: nil,
                imageUrl: "" // Corrected: Pass `nil` if there's no image URL
            ))
        }
    }
}
