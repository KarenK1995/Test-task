//
//  CategoriesSelectorView.swift
//  LoopTestTask
//
//  Created by Karen Karapetyan on 5/8/19.
//  Copyright © 2019 Karen Karapetyan. All rights reserved.
//

import UIKit

protocol CategoriesSelectorViewDelegate: NSObjectProtocol {
    func didSelectCategory(category: Category)
}

class CategoriesSelectorView: UIView {
    
    let cellID = "Cell"
    var collectionView: UICollectionView!
    var isDefaultItemSelected = false
    
    var categories = Categories.shared.all
    
    var delegate: CategoriesSelectorViewDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    private func setup() {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 120, height: 50)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        
        collectionView.backgroundColor = .white
        addSubview(collectionView)
        
        let selctedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selctedIndexPath, animated: true, scrollPosition: .left)
        delegate?.didSelectCategory(category: categories[selctedIndexPath.row])
        self.collectionView = collectionView
    }
}

extension CategoriesSelectorView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CategoryCollectionViewCell
        cell.category = categories[indexPath.row]
        return cell
    }
}

extension CategoriesSelectorView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollRightForIndexPath(indexPath)
        delegate?.didSelectCategory(category: categories[indexPath.row])
    }
    
    
}

extension CategoriesSelectorView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 50
        let width = categories[indexPath.row].name.width(withConstraintedHeight: height, font: UIFont.systemFont(ofSize: 16, weight: .bold))
        return CGSize(width: width, height: height)
    }
}
