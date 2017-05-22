//
//  MainRootController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class MainRootController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var currentTab = "profile"
    var currentBottomTab = "myRewards"
    
    @IBOutlet weak var TableViewText: UILabel!
    
    @IBOutlet weak var ProfileXConstraint: NSLayoutConstraint!
    @IBOutlet weak var RewardsXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    @IBOutlet weak var profilePageOutlet: UIButton!
    @IBOutlet weak var rewardsPageOutlet: UIButton!
    @IBOutlet weak var collectPageOutlet: UIButton!
    
    
    
    
    
    @IBOutlet weak var myRewardsView: UIView!
    @IBOutlet weak var bottomMyRewards: UIView!
    @IBOutlet weak var myChallengesView: UIView!
    @IBOutlet weak var bottomMyChallenges: UIView!
    @IBOutlet weak var myRewardsOutlet: UIButton!
    @IBOutlet weak var myChallengesOutlet: UIButton!
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.allowsSelection = false
        
        if currentBottomTab == "myRewards" {
            
            self.TableViewText.text = "Click on the reward you would like to redeem and follow the instructions in the presence of the store cashier."
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myRewards", for: indexPath) as! MyRewardsCell
            
            return cell
            
        } else {
            
            self.TableViewText.text = "Challenges are gien out on a weekly basis and expire at the end of the week, so make sure to get them done in time!"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myChallenges", for: indexPath) as! MyRewardsCell
            
            return cell
            
        }

    }
    
    
    
    @IBAction func profileSelect(_ sender: Any) {
        
        print(currentTab)
        
        let screenWidth = self.view.bounds.width
        
        UIView.animate(withDuration: 0.3, animations: {

            self.ProfileXConstraint.constant = 0
            self.RewardsXConstraint.constant = screenWidth
            
            self.profilePageOutlet.setImage(UIImage(named: "profileSelected"), for: .normal)
            self.collectPageOutlet.setImage(UIImage(named: "collectUnselected"), for: .normal)
            self.rewardsPageOutlet.setImage(UIImage(named: "rewardsUnselected"), for: .normal)
            
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.currentTab = "profile"
            
        }

    }
    
    
    @IBAction func collectSelect(_ sender: Any) {
        
        print(currentTab)
        
        let screenWidth = self.view.bounds.width
        
        UIView.animate(withDuration: 0.3, animations: {

            self.ProfileXConstraint.constant = -screenWidth
            self.RewardsXConstraint.constant = screenWidth
            
            self.profilePageOutlet.setImage(UIImage(named: "profileUnselected"), for: .normal)
            self.collectPageOutlet.setImage(UIImage(named: "collectSelected"), for: .normal)
            self.rewardsPageOutlet.setImage(UIImage(named: "rewardsUnselected"), for: .normal)

            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.currentTab = "collect"
            
        }
    }

    
    @IBAction func rewardsSelect(_ sender: Any) {
        
        print(currentTab)
        
        UIView.animate(withDuration: 0.3, animations: {

        self.RewardsXConstraint.constant = 0
            
            
            self.profilePageOutlet.setImage(UIImage(named: "profileUnselected"), for: .normal)
            self.collectPageOutlet.setImage(UIImage(named: "collectUnselected"), for: .normal)
            self.rewardsPageOutlet.setImage(UIImage(named: "rewardsSelected"), for: .normal)
        
        self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.currentTab = "rewards"
            
        }
    }
    
    
    @IBAction func myRewards(_ sender: Any) {
        
        currentBottomTab = "myRewards"
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.myRewardsView.backgroundColor = UIColor.white
            self.bottomMyRewards.backgroundColor = UIColor.white
            self.myChallengesView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.bottomMyChallenges.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            
            self.myRewardsOutlet.setTitleColor(UIColor.black, for: .normal)
            self.myChallengesOutlet.setTitleColor(UIColor.white, for: .normal)
            
         
            
            
        }) 
        
        self.myTableView.reloadData()
    }
    
    

    @IBAction func myChallenges(_ sender: Any) {
        
        currentBottomTab = "myChallenges"
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.myRewardsView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.bottomMyRewards.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.myChallengesView.backgroundColor = UIColor.white
            self.bottomMyChallenges.backgroundColor = UIColor.white
            
            self.myRewardsOutlet.setTitleColor(UIColor.white, for: .normal)
            self.myChallengesOutlet.setTitleColor(UIColor.black, for: .normal)
            
            
        })
        
        self.myTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.bounds.width
        self.RewardsXConstraint.constant = width
        
        self.myRewardsView.layer.cornerRadius = 10
        self.myChallengesView.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
