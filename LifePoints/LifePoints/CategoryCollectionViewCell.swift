//
//  CategoryCollectionViewCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-21.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var supplementsImage: UIImageView!
    @IBOutlet weak var supplementsLabel: UILabel!
    
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
}
