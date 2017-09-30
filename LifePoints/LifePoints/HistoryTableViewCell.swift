//
//  HistoryTableViewCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-09-17.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var partnerOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var pointsOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
