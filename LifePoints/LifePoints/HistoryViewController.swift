//
//  HistoryViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-09-16.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var mainRootController: MainRootController?
 
    @IBOutlet weak var myTableView: UITableView!

    var history = [[String:Any]]()
    
    @IBAction func closeHistory(_ sender: Any) {
        
        mainRootController?.toggleHistory(action: "close", completion: { (bool) in
            
            print("history closed")
            
        })
        
    }
    
    
    
    func loadHistory(){
        
        if let myUID = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("users").child(myUID)
            
            ref.keepSynced(true)
            
            ref.child("rewardsHistory").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let data = snapshot.value as? [String:Any] {
                    
                    for (key, value) in data {
                        
                        if let appendValue = value as? [String : Any] {
                            
                            self.history.insert(appendValue, at: 0)
                            
        
                            
                        }
                        
                        
                        
                    }
                    
                    print(self.history)
                    self.myTableView.reloadData()

                }
            })
            
            
        }
        
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return history.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        
        if let rewardDescription = history[indexPath.row]["title"] as? String {
            
            cell.partnerOutlet.text = rewardDescription
            
        }
        
        if let partner = history[indexPath.row]["partner"] as? String {
            
            cell.titleOutlet.text = partner
            
        }
        
        if let points = history[indexPath.row]["points"] as? Int {
            
            cell.pointsOutlet.text = String(points)
            
        }
        
        if let interval = history[indexPath.row]["date"] as? TimeInterval {
            
            let date = NSDate(timeIntervalSince1970: interval)
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy HH:mm"
            let stringDate = formatter.string(from: date as Date)
            
            
            cell.dateOutlet.text = stringDate
            
        }
        
        return cell
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
