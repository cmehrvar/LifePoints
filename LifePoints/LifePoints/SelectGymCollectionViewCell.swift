//
//  SelectGymCollectionViewCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-07-03.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class SelectGymCollectionViewCell: UICollectionViewCell {
    
    weak var signUpController: ThirdSignUpViewController?
    
    var index: Int?
    
    @IBOutlet weak var selectedBox: UIImageView!
    
    @IBAction func selectGym(_ sender: Any) {
        
        signUpController?.selectedGymIndex = index
        signUpController?.gymCollectionViewOutlet.reloadData()
        
    }
    
    
}
