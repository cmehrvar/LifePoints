//
//  MyChallengesTableViewCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-08-30.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class MyChallengesTableViewCell: UITableViewCell {

    


    @IBOutlet weak var descriptionOutlet: UILabel!
    @IBOutlet weak var pointsOutlet: UILabel!
    @IBOutlet weak var obtainValueOutlet: UILabel!
    @IBOutlet weak var obtainUnitOutlet: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
