//
//  MenuViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-07-03.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class MenuViewController: UIViewController, UIGestureRecognizerDelegate {

    
    weak var mainRoot: MainRootController?
    
    
    
    
    
    @IBAction func facebook(_ sender: Any) {
        
        if let url = URL(string: "https://www.facebook.com/LifePointsOFC/") {
            
            UIApplication.shared.openURL(url)
            
        }
        
        
        
    }
    
    
    @IBAction func twitter(_ sender: Any) {
        
        if let url = URL(string: "https://twitter.com/LifePointsOFC") {
            
            UIApplication.shared.openURL(url)
            
        }
    }
    
    
    @IBAction func instagram(_ sender: Any) {
        
        if let url = URL(string: "https://www.instagram.com/lifepointsapp/") {
            
            UIApplication.shared.openURL(url)
            
        }
        
    }
 
    
    
    
    @IBAction func callHistory(_ sender: Any) {
        
        
        mainRoot?.toggleMenu(completion: { (bool) in
            
            self.mainRoot?.toggleHistory(action: "open", completion: { (bool) in
                
                print("history opened")
                
                
            })
            
        })
        
        
    }
    
    
    
    @IBAction func singOut(_ sender: Any) {
        
        if let uid = Auth.auth().currentUser?.uid {
            
            Database.database().reference().child("users").child(uid).child("online").setValue(false)
            
            FBSDKLoginManager().logOut()
            
            var scopeError: Error?
            
            do {
                try Auth.auth().signOut()
            } catch let error {
                
                scopeError = error
                
                print(error)
            }
            
            if scopeError == nil {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogIn") as! LogInController
                
                present(vc, animated: true) {
                    
                    
                    
                }
            }
        } else {
            
            //////MUST REMOVE THIS!!!! JUST PLACEHOLDER
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogIn") as! LogInController
            
            present(vc, animated: true) {
                
                
                
            }

            
        }
    }
    
    func closeMenu(){
        
        mainRoot?.toggleMenu(completion: { (bool) in
            
            print("menu closed")
            
        })
        
    }
    
    @IBAction func changeGym(_ sender: Any) {
        
        mainRoot?.toggleMenu(completion: { (bool) in
            
            self.mainRoot?.toggleMainGym()
            
        })
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeMenu))
        leftSwipeGestureRecognizer.direction = .left
        leftSwipeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)

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
