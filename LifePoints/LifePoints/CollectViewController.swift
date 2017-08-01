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
    
    var collectedPoints = 0

    weak var mainRootController: MainRootController?
    
    @IBOutlet weak var lpCollectNumberView: UIView!
    @IBOutlet weak var collectButtonOutlet: UIButton!
    @IBOutlet weak var CurrentNumberCollected: UILabel!
    @IBOutlet weak var inRangeOutlet: UIImageView!
    
    
    @IBOutlet weak var inRangeImage: UIImageView!
    
    var beginCollectingTimer = Timer()
    
    
    @IBAction func collectButton(_ sender: Any) {
        
        lpCollectNumberView.alpha = 1
        collectButtonOutlet.alpha = 0
        
        CurrentNumberCollected.text = "0"
        
        beginCollectingTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateLifePoints), userInfo: nil, repeats: true)
        
    }
    
    
    func updateLifePoints(){
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let pointsRef = Database.database().reference().child("users").child(uid).child("points")
            pointsRef.keepSynced(true)
            
            pointsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let points = snapshot.value as? Int {
                    
                    let newPoints = points + 1
                    self.collectedPoints += 1
                    self.CurrentNumberCollected.text = String(self.collectedPoints)
                    pointsRef.setValue(newPoints)
                    
                }
            })
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpCollectNumberView.alpha = 0
        collectButtonOutlet.alpha = 1
        
        collectButtonOutlet.setImage(UIImage(named: "BeginCollecting"), for: .normal)
        collectButtonOutlet.setImage(UIImage(named: "CantCollect"), for: .disabled)

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
