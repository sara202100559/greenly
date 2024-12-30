//
//  SuggestedProductsCell.swift
//  Greenly
//

import UIKit

class SuggestedProductsCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products: [Product] = []
    var onProductTap: ((Product) -> Void)?
    
    func configure(with products: [Product]) {
        self.products = products
        collectionView.reloadData()
    }
}

extension SuggestedProductsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedProductCollectionCell", for: indexPath) as! SuggestedProductCollectionCell
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onProductTap?(products[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 150)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self

        // Register the collection view cell
        collectionView.register(UINib(nibName: "SuggestedProductCollectionCell", bundle: .main), forCellWithReuseIdentifier: "SuggestedProductCollectionCell")
    }


}
