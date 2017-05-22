//
//  AllPartnersCollectionCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-21.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class AllPartnersCollectionCell: UICollectionViewCell {
    
    
    weak var allPartnersController: AllPartnersViewController?
    
    
    
    @IBAction func selectStore(_ sender: Any) {
        
        allPartnersController?.toggleSelectedStore(action: "open", completion: { (bool) in
            
            print("store selected")
            
        })
        
    }
    
    
    
}
