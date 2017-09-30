//
//  MyRewardsCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import NYAlertViewController
import Firebase

class MyRewardsCell: UITableViewCell {
    
    
    @IBOutlet weak var descriptionOutlet: UILabel!
    @IBOutlet weak var partnerName: UILabel!
    @IBOutlet weak var pointsOutlet: UILabel!
    
    var partner = ""
    var title = ""
    var points = 0
    
    
    weak var mainrootcontroller: MainRootController?
    
    var rewardUID = ""
    var rewardPoints = 0
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    
    
    @IBAction func redeem(_ sender: Any) {
        
        self.mainrootcontroller?.redemptionDescriptionOutlet.text = title
        self.mainrootcontroller?.partnerDescriptionOutlet.text = partner
        
        self.mainrootcontroller?.rewardTitleToRedeem = title
        self.mainrootcontroller?.rewardUIDtoRedeem = rewardUID
        self.mainrootcontroller?.rewardPointsToRedeem = points
        self.mainrootcontroller?.rewardPartnerToRedeem = partner
        
        self.mainrootcontroller?.redemptionSliderConstOutlet.constant = 2
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.mainrootcontroller?.redeemViewOutlet.alpha = 1
            self.mainrootcontroller?.blurViewOutletj.alpha = 1
            self.mainrootcontroller?.view.layoutIfNeeded()
            
        }) { (bool) in
            
            print("redeem opened")
            
            
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
