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
    
    
    @IBOutlet weak var myRewardsView: UIView!
    @IBOutlet weak var myChallengesView: UIView!
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
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.currentTab = "collect"
            
        }
    }

    
    @IBAction func rewardsSelect(_ sender: Any) {
        
        print(currentTab)
        
        UIView.animate(withDuration: 0.3, animations: {

        self.RewardsXConstraint.constant = 0
        self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.currentTab = "rewards"
            
        }
    }
    
    
    @IBAction func myRewards(_ sender: Any) {
        
        currentBottomTab = "myRewards"
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.myRewardsView.backgroundColor = UIColor.white
            self.myChallengesView.backgroundColor = UIColor.purple
            
            self.myRewardsOutlet.setTitleColor(UIColor.black, for: .normal)
            self.myChallengesOutlet.setTitleColor(UIColor.white, for: .normal)
            
        }) 
        
        self.myTableView.reloadData()
    }
    
    

    @IBAction func myChallenges(_ sender: Any) {
        
        currentBottomTab = "myChallenges"
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.myRewardsView.backgroundColor = UIColor.purple
            self.myChallengesView.backgroundColor = UIColor.white
            
            self.myRewardsOutlet.setTitleColor(UIColor.white, for: .normal)
            self.myChallengesOutlet.setTitleColor(UIColor.black, for: .normal)
            
        })
        
        self.myTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.bounds.width
        self.RewardsXConstraint.constant = width

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

}
