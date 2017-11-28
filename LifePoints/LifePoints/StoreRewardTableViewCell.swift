//
//  StoreRewardTableViewCell.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-22.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import NYAlertViewController
import Firebase

class StoreRewardTableViewCell: UITableViewCell {
    
    weak var selectedStoreController: SelectedStoreViewController?
    
    var rewardUID = ""
    
    @IBOutlet weak var pointsOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UILabel!
    
    var points: Int = 0
    var someDescription = ""
    var storeName = ""
    
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

    
    
    @IBAction func redeemRewards(_ sender: Any) {
        
        let alertController = NYAlertViewController()
        
        if let myUID = Auth.auth().currentUser?.uid {
            
            let topRef = Database.database().reference().child("users").child(myUID)
            
            topRef.keepSynced(true)
            
            topRef.child("points").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let myPoints = snapshot.value as? Int {
                    
                    alertController.backgroundTapDismissalGestureEnabled
                        = true
                    
                    
                    //HERE
                    alertController.buttonColor = self.hexStringToUIColor(hex: "50D6E3")
                    
                    alertController.addAction(NYAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        
                        self.selectedStoreController?.dismiss(animated: true, completion: nil)
                        //do nothing
                        
                    }))

                    
                    if myPoints >= self.points {
                        
                        alertController.title = "Redeem for \(self.points.description) LifePoints?"

                        alertController.message = self.someDescription
                        
                        alertController.addAction(NYAlertAction(title: "Confirm", style: .default, handler: { (action) in
                            
                            let reward: [String : Any] = ["description":self.someDescription, "name":self.storeName, "points": self.points]
                            
                            if let myUID = Auth.auth().currentUser?.uid {
                                
                                let ref = Database.database().reference().child("users").child(myUID)
                                
                                ref.child("myrewards").child(self.rewardUID).setValue(reward)
                                
                                ref.child("points").setValue(myPoints-self.points)
                                
                            }

                            self.selectedStoreController?.dismiss(animated: true, completion: nil)

                            
                        }))

                        
                    } else {
                        
                        alertController.title = "Not Enough Points"
                
                        alertController.message = "Sorry, you do not have enough LifePoints to redeem this item at this time. Go to the gym!"
                        
                        
                    }

                    self.selectedStoreController?.present(alertController, animated: true, completion: nil)

                }
                
                
            })
            
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
