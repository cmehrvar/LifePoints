//
//  HoursOfOperationTableViewCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-22.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class HoursOfOperationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hoursNotListed: UIView!
    
    @IBOutlet weak var mondayTime: UILabel!
    @IBOutlet weak var tuesdayTime: UILabel!
    @IBOutlet weak var wednesdayTime: UILabel!
    @IBOutlet weak var thursdayTime: UILabel!
    @IBOutlet weak var fridayTime: UILabel!
    @IBOutlet weak var saturdayTime: UILabel!
    @IBOutlet weak var sundayTime: UILabel!
    
    
    var website = ""
    
    
    @IBAction func website(_ sender: Any) {
        
        if let url = URL(string: website) {
            
            if !UIApplication.shared.openURL(url) {
                
                print("failed to open")
                
            }
            
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
