//
//  ProfileViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//A29DCB

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    func loadPage(){
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("users").child(uid)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let data = snapshot.value as? [AnyHashable : Any] {
                    
                    if let firstName = data["firstName"] as? String, let lastName = data["lastName"] as? String {
                        
                        
                        self.nameOutlet.text = firstName + " " + lastName
                        
                    }
                    
                    if let profilePic = data["profilePicture"] as? String, let url = URL(string: profilePic) {
                        
                        self.profileImage.sd_setImage(with: url)
                        self.backgroundImage.sd_setImage(with: url)
                        
                    }
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPage()
        
        self.profileImage.layer.cornerRadius = 45
        self.profileImage.layer.borderColor = hexStringToUIColor(hex: "A29DCB").cgColor
        self.profileImage.layer.borderWidth = 2

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
