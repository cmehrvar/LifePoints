//
//  AllPartnersCollectionCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-21.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class PartnerCollectionCell: UICollectionViewCell {
    
    
    weak var rewardsController: RewardsViewController?
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var buisinessUID = ""
    
    
    
    
    @IBAction func selectStore(_ sender: Any) {
        
        self.rewardsController?.selectedStoreController?.businessUID = self.buisinessUID
        self.rewardsController?.selectedStoreController?.loadInfo()
        
        rewardsController?.toggleSelectedStore(direction: "open", completion: { (bool) in
            
            
            
            print("store selected")
            
        })
        
    }
    
    
    
}
