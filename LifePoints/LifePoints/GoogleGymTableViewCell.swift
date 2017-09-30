//
//  GoogleGymTableViewCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-09-25.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class GoogleGymTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var placeOutlet: UILabel!
    @IBOutlet weak var locationOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.locationOutlet.adjustsFontSizeToFitWidth = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
