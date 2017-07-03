//
//  HeaderCollectionReusableView.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-21.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    weak var rewardsViewController: RewardsViewController?
    
    @IBAction func presentAllPartners(_ sender: Any) {
        
        rewardsViewController?.toggleAllPartners(direction: "open", completion: { (bool) in
            
            print("all partners presented")
            
        })
        
        
    }
    
        
}
