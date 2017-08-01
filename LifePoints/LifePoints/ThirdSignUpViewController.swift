//
//  ThirdSignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-29.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase

class ThirdSignUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var signUpTwo: secondSignUpViewController?
    @IBOutlet weak var gymCollectionViewOutlet: UICollectionView!
    
    var selectedGymIndex: Int?
    
    
    @IBAction func finish(_ sender: Any) {
        
        if selectedGymIndex == nil {
            
            let alertController = UIAlertController(title: "No Gym Selected", message: "Please select your gym to sign up!", preferredStyle:  UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                
                
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            //Sign Up
            if let email = signUpTwo?.firstSignUp?.usernameTextOutlet.text, let password = signUpTwo?.firstSignUp?.passwordTextOutlet.text, let firstName = signUpTwo?.firstNameTextOutlet.text, let lastName = signUpTwo?.lastNameTextOutlet.text, let sex = signUpTwo?.sex, let age = signUpTwo?.ageDownPicker.text {
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    
                    if error == nil {
                        
                        var userData = [AnyHashable: Any]()
     
                        
                        userData["age"] = age

                            userData["email"] = email


                            userData["gender"] = sex

                        
         
                            userData["firstName"] = firstName
           
     
                            userData["lastName"] = lastName
                        
                        userData["gym"] = "someGym\(self.selectedGymIndex)"
                        userData["points"] = 0

                        
                        
                        userData["uid"] = user?.uid
                        userData["online"] = true
                        userData["lastActive"] = Date().timeIntervalSince1970
                        
                        let ref = Database.database().reference()
                        ref.keepSynced(true)
                        
                        if let uid = user?.uid {
                            
                            ref.child("users").child(uid).setValue(userData)
                            
                        }
                        
                        
                        
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainRootController") as?  MainRootController {
                            
                            self.present(vc, animated: true, completion: {
                                
                            })
                        }

                    } else {
                        
                        print(error)
                        
                    }
                    
                })

                
                
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gymCell", for: indexPath) as! SelectGymCollectionViewCell
        
        cell.index = indexPath.row
        cell.signUpController = self
        
        if let index = selectedGymIndex {
            
            if indexPath.row == index {
                
                cell.selectedBox.image = UIImage(named:"checkedBox")
                
            } else {
                
                cell.selectedBox.image = UIImage(named:"uncheckedBox")
                
            }
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.layer.bounds.width, height: 68)
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        signUpTwo?.toggleThree(direction: "close", completion: { (bool) in
            
            
            
        })
        
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
