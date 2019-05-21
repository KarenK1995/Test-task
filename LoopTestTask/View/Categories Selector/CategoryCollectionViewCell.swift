//
//  CategoryCollectionViewCell.swift
//  LoopTestTask
//
//  Created by Karen Karapetyan on 5/8/19.
//  Copyright © 2019 Karen Karapetyan. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    
    var category: Category! {
        didSet {
            nameLabel.text = category.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                nameLabel.textColor = .darkGray
                underlineView.isHidden = false
            }
            else {
                nameLabel.textColor = .lightGray
                underlineView.isHidden = true
            }
        }
    }
}
