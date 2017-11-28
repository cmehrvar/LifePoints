//
//  CollectViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase

class CollectViewController: UIViewController {
    
    var collecting = false

    weak var mainRootController: MainRootController?
    
    @IBOutlet weak var lpCollectNumberView: UIView!
    @IBOutlet weak var collectButtonOutlet: UIButton!
    @IBOutlet weak var CurrentNumberCollected: UILabel!
    @IBOutlet weak var inRangeOutlet: UIImageView!
    @IBOutlet weak var gymName: UILabel!
    @IBOutlet weak var gymAddress: UILabel!
    
    @IBOutlet weak var dailyLimitOutlet: UILabel!
    
    @IBOutlet weak var inRangeImage: UIImageView!
    
    var referenceDate = NSDate().timeIntervalSince1970
    
    @IBAction func collectButton(_ sender: Any) {

        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("users").child(uid)
            
            ref.keepSynced(true)
            
            ref.child("startCollectTime").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if !snapshot.exists() {
                    
                    ref.child("startCollectTime").setValue(NSDate().timeIntervalSince1970)
                    ref.child("pointsCollectedToday").setValue(0)
                    
                } else {
                    
                    if let collectTime = snapshot.value as? TimeInterval {
                        
                        if NSDate().timeIntervalSince1970-collectTime > 28800 {
                            
                            ref.child("startCollectTime").setValue(NSDate().timeIntervalSince1970)
                            ref.child("pointsCollectedToday").setValue(0)

                        }
                    }
                }
                
                self.lpCollectNumberView.alpha = 1
                self.collectButtonOutlet.alpha = 0
    
                self.collecting = true
                self.referenceDate = NSDate().timeIntervalSince1970
                
            })
        }
    }
    
    
    func updateLifePoints(){
        
        if let uid = Auth.auth().currentUser?.uid {

            let pointsRef = Database.database().reference().child("users").child(uid).child("points")
            pointsRef.keepSynced(true)
            
            pointsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let points = snapshot.value as? Int {
                    
                    let newPoints = points + 1
                    
                    self.pointsCollectedToday += 1
                    
                    if self.pointsCollectedToday == 1000 {
                        
                        self.dailyLimitOutlet.alpha = 1
           
                    }
                    
                    Database.database().reference().child("users").child(uid).child("pointsCollectedToday").setValue(self.pointsCollectedToday)
 
                    pointsRef.setValue(newPoints)
                    
                }
            })
        }
    }
    
    var pointsCollectedToday = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpCollectNumberView.alpha = 0
        collectButtonOutlet.alpha = 1
        
        collectButtonOutlet.setImage(UIImage(named: "BeginCollecting"), for: .normal)
        collectButtonOutlet.setImage(UIImage(named: "CantCollect"), for: .disabled)
        
        if let uid = Auth.auth().currentUser?.uid {

            Database.database().reference().child("users").child(uid).child("pointsCollectedToday").observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? Int {
                    
                    self.pointsCollectedToday = value
                    self.CurrentNumberCollected.text = String(value)
                    
                }
            })
        }

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
