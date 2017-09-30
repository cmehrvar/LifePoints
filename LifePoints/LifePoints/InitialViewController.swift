//
//  InitialViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-07-07.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                
                if let uid = Auth.auth().currentUser?.uid {
                
                    Database.database().reference().child("users").child(uid).child("myGymLongitude").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if snapshot.exists() {
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainRootController") as! MainRootController
                            
                            self.present(vc, animated: true, completion: {
                                
                                
                            })
                            
                        } else {
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "thirdSignUp") as! ThirdSignUpViewController
                            
                            self.present(vc, animated: true, completion: {
                                
                                vc.cameFromFacebook = true
                                
                                vc.backButton.alpha = 0
                                vc.pageNumber.alpha = 0
                                vc.haveAnAccount.alpha = 0
                                
                                
                            })
                            
                            
                            
                        }
                        
                    })
                    
                }
                
                
                
                
            } else {
                
                FBSDKLoginManager().logOut()
                
                do {
                    try Auth.auth().signOut()
                } catch let error {
                    print(error)
                }
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogIn") as? LogInController {
                    self.present(vc, animated: true, completion: nil)
                    
                }
            }
        })

        
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
