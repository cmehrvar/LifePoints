//
//  SelectedStoreViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-22.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase


class SelectedStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    weak var rewardsViewController: RewardsViewController?
    
    var businessUID = ""
    
    var bio = ""
    
    var currentTab = "Rewards"
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var rewardsView: UIView!
    @IBOutlet weak var bottomRewardsView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var bottomMoreView: UIView!
    @IBOutlet weak var rewardsButtonOutlet: UIButton!
    @IBOutlet weak var moreButtonOutlet: UIButton!
    
    
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var bioOutlet: UILabel!
    
    @IBOutlet weak var bannerOutlet: UIImageView!

    var hoursListed = false
    
    var storeName = ""
    
    var mondayTime = ""
    var tuesdayTime = ""
    var wednesdayTime = ""
    var thursdayTime = ""
    var fridayTime = ""
    var saturdayTime = ""
    var sundayTime = ""
    
    var website = ""
    
    var rewardUIDs = [String]()
    var rewardPoints = [Int]()
    var rewardDescriptions = [String]()
    
    
    func loadInfo(){
        
        let ref = Database.database().reference().child("Partners").child(businessUID)
        
        ref.keepSynced(true)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String : Any] {
 
                
                if let site = data["WebSite"] as? String {
                    
                    self.website = site
                    
                }
                
                
                if let hours = data["Hours"] as? [Any] {
                    
                    print(hours)
                    
                    self.hoursListed = true
                    
                    for i in 0..<hours.count {
                        
                        switch i {
                            
                        case 0:
                            
                            if let dict = hours[i] as? [AnyHashable:Any], let from = dict["from"] as? String, let to = dict["to"] as? String, let closed = dict["closed"] as? Bool {
                                
                                if closed {
                                    
                                    self.mondayTime = "closed"
                                    
                                } else {
                                    
                                    self.mondayTime = from + " to " + to
                                    
                                }
                                
                            }
                            
    
                        case 1:
                            
                            if let dict = hours[i] as? [AnyHashable:Any], let from = dict["from"] as? String, let to = dict["to"] as? String, let closed = dict["closed"] as? Bool {
                                
                                if closed {
                                    
                                    self.tuesdayTime = "closed"
                                    
                                } else {
                                    
                                    self.tuesdayTime = from + " to " + to
                                    
                                }
                                
                            }

                            
                            
                        case 2:
                            
                            if let dict = hours[i] as? [AnyHashable:Any], let from = dict["from"] as? String, let to = dict["to"] as? String, let closed = dict["closed"] as? Bool {
                                
                                if closed {
                                    
                                    self.wednesdayTime = "closed"
                                    
                                } else {
                                    
                                    self.wednesdayTime = from + " to " + to
                                    
                                }
                                
                            }

                            
                            
                        case 3:
                            
                            if let dict = hours[i] as? [AnyHashable:Any], let from = dict["from"] as? String, let to = dict["to"] as? String, let closed = dict["closed"] as? Bool {
                                
                                if closed {
                                    
                                    self.thursdayTime = "closed"
                                    
                                } else {
                                    
                                    self.thursdayTime = from + " to " + to
                                    
                                }
                                
                            }
                            
                        case 4:
                            
                            if let dict = hours[i] as? [AnyHashable:Any], let from = dict["from"] as? String, let to = dict["to"] as? String, let closed = dict["closed"] as? Bool {
                                
                                if closed {
                                    
                                    self.fridayTime = "closed"
                                    
                                } else {
                                    
                                    self.fridayTime = from + " to " + to
                                    
                                }
                                
                            }
                            
                            
                        case 5:
                            
                            if let dict = hours[i] as? [AnyHashable:Any], let from = dict["from"] as? String, let to = dict["to"] as? String, let closed = dict["closed"] as? Bool {
                                
                                if closed {
                                    
                                    self.saturdayTime = "closed"
                                    
                                } else {
                                    
                                    self.saturdayTime = from + " to " + to
                                    
                                }
                                
                            }
                            
                            
                        case 6:
                            
                            if let dict = hours[i] as? [AnyHashable:Any], let from = dict["from"] as? String, let to = dict["to"] as? String, let closed = dict["closed"] as? Bool {
                                
                                if closed {
                                    
                                    self.sundayTime = "closed"
                                    
                                } else {
                                    
                                    self.sundayTime = from + " to " + to
                                    
                                }
                            }
                            
                            
                        default:
                            
                            break
                            
                        }
                    }
                } else {
                    
                    self.hoursListed = false
                    
                }
                
                
                if let name = data["Name"] as? String {
                    
                    self.storeName = name
                    self.nameOutlet.text = name
                    
                }
                
                if let address = data["Address"] as? String {
                    
                    self.addressOutlet.text = address
                    
                }
                
                if let bio = data["bio"] as? String {
                    
                    self.bio = bio
                    
                }
                
                if let banner = data["Banner"] as? String, let url = NSURL(string: banner) {
                    
                    self.bannerOutlet.sd_setImage(with: url as URL)
                    
                }

                if let rewards = data["Rewards"] as? [String : Any]{
                    
                    for (key, value) in rewards {
                        
                        if let dictValue = value as? [String : Any] {
                            
                            print(dictValue)
                            
                            if let description = dictValue["RewardDescription"] as? String, let LPValue = dictValue["LPValue"] as? String {
                                
                                self.rewardUIDs.append(key)
                                self.rewardDescriptions.append(description)
                                
                                if let intPoints = Int(LPValue) {
                                    
                                    self.rewardPoints.append(intPoints)
                                    
                                }
                            }
                        }
                    }
                }

                print(self.rewardUIDs)
                print(self.rewardDescriptions)
                print(self.rewardPoints)
                
                self.myTableView.reloadData()
                
            }
        })
    }
    
    
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
        
        rewardUIDs.removeAll()
        rewardDescriptions.removeAll()
        rewardPoints.removeAll()
        
        myTableView.reloadData()
        
        rewardsViewController?.toggleSelectedStore(direction: "close", completion: { (bool) in
            
            print("selected store closed")
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.allowsSelection = false

        if currentTab == "Rewards" {
            
            bioOutlet.text = "Click on the reward you would like to redeem your LifePoints for. Rewards will be put into the 'My Rewards' folder."
            
            let rewardCell = tableView.dequeueReusableCell(withIdentifier: "reward", for: indexPath) as! StoreRewardTableViewCell
            
            rewardCell.selectedStoreController = self
            
            rewardCell.pointsOutlet.text = String(rewardPoints[indexPath.row])
            rewardCell.descriptionOutlet.text = rewardDescriptions[indexPath.row]
            
            rewardCell.rewardUID = rewardUIDs[indexPath.row]
            
            rewardCell.points = rewardPoints[indexPath.row]
            rewardCell.someDescription = rewardDescriptions[indexPath.row]
            
            rewardCell.storeName = storeName
            
            return rewardCell
            
            
            
        } else {
        
            
            bioOutlet.text = self.bio
            
            let hoursCell = tableView.dequeueReusableCell(withIdentifier: "hoursOfOperation", for: indexPath) as! HoursOfOperationTableViewCell
            
            if hoursListed == true {
                
                hoursCell.hoursNotListed.alpha = 0
                
            } else {
                
                hoursCell.hoursNotListed.alpha = 1
                
            }
            
            hoursCell.mondayTime.text = mondayTime
            hoursCell.tuesdayTime.text = tuesdayTime
            hoursCell.wednesdayTime.text = wednesdayTime
            hoursCell.thursdayTime.text = thursdayTime
            hoursCell.fridayTime.text = fridayTime
            hoursCell.saturdayTime.text = saturdayTime
            hoursCell.sundayTime.text = sundayTime
            
            hoursCell.website = website
  
            return hoursCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if currentTab == "Rewards" {
            
            return rewardUIDs.count
            
        } else {
            
            return 1
            
        }
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
