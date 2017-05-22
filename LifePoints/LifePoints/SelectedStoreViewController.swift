//
//  SelectedStoreViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-22.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class SelectedStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    weak var allPartnersViewController: AllPartnersViewController?
    
    var currentTab = "Rewards"
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tableViewText: UILabel!
    
    
    
    
    @IBOutlet weak var rewardsView: UIView!
    @IBOutlet weak var bottomRewardsView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var bottomMoreView: UIView!
    @IBOutlet weak var rewardsButtonOutlet: UIButton!
    @IBOutlet weak var moreButtonOutlet: UIButton!
    
    
    @IBAction func rewards(_ sender: Any) {
        
        currentTab = "Rewards"
        self.myTableView.reloadData()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.rewardsView.backgroundColor = UIColor.white
            self.bottomRewardsView.backgroundColor = UIColor.white
            
            self.moreView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.bottomMoreView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
        
            self.rewardsButtonOutlet.setTitleColor(UIColor.black, for: .normal)
            self.moreButtonOutlet.setTitleColor(UIColor.white, for: .normal)
            
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            print("rewards selected")

        }
 
    }
    
    @IBAction func more(_ sender: Any) {
        
        currentTab = "More"
        self.myTableView.reloadData()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.rewardsView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.bottomRewardsView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            
            self.moreView.backgroundColor = UIColor.white
            self.bottomMoreView.backgroundColor = UIColor.white
            
            self.rewardsButtonOutlet.setTitleColor(UIColor.white, for: .normal)
            self.moreButtonOutlet.setTitleColor(UIColor.black, for: .normal)
            
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            print("rewards selected")

        }
    }
    
    @IBAction func back(_ sender: Any) {
        
        allPartnersViewController?.toggleSelectedStore(action: "close", completion: { (bool) in
            
            print("selected store closed")
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.allowsSelection = false
        
        var cell = UITableViewCell()
        
        if currentTab == "Rewards" {
            
            tableViewText.text = "Click on the reward you would like to redeem your LifePoints for. Rewards will be put into the 'My Rewards' folder."
            
            cell = tableView.dequeueReusableCell(withIdentifier: "reward", for: indexPath) as! StoreRewardTableViewCell
            
        } else if currentTab == "More" {
            
            tableViewText.text = "Canada's leading sports nutrition stores since 1989. Lowest supplement prices guaranteed with over 120 locations across Canada."
            
            cell = tableView.dequeueReusableCell(withIdentifier: "hoursOfOperation", for: indexPath) as! HoursOfOperationTableViewCell
            
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if currentTab == "Rewards" {
            
            return 57
            
        } else {
            
            return 156

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rewardsView.layer.cornerRadius = 10
        self.moreView.layer.cornerRadius = 10
        
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
