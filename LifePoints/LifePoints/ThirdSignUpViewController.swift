//
//  ThirdSignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-29.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class ThirdSignUpViewController: UIViewController, UICollectionViewDelegateFlowLayout, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var globLocation: CLLocation!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var cameFromFacebook = false
    
    
    
    @IBOutlet weak var buttonView: UIView!
    
    weak var signUpTwo: secondSignUpViewController?
    weak var gymSelectController: GoogleGymViewController?
    
    @IBOutlet weak var gymCollectionViewOutlet: UICollectionView!
    
    @IBOutlet weak var selectGymConstOutlet: NSLayoutConstraint!
    
    @IBOutlet weak var gymButtonOutlet: UIButton!
    @IBOutlet weak var gymAddress: UILabel!
    
    
    
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var haveAnAccount: UIView!
    
    
    

    var selectedGymName = ""
    var selectedGymAddress = ""
    var selectedGymLat: CLLocationDegrees = 0
    var selectedGymLong: CLLocationDegrees = 0

    var selectGymOpen = false
    
    var selectedGymIndex: Int?
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        
    }
    
    

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        
        
    }
    
    
    func toggleSelectGym(){
        
        var const: CGFloat = 0
        
        if selectGymOpen == true {
            
            const = self.view.bounds.height
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.selectGymConstOutlet.constant = const
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.selectGymOpen = !self.selectGymOpen
            
        }
        
        
        
    }
    
    
    func updateLocation(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let lastLocation = locations.last {
            
            globLocation = lastLocation
            
            
        }
    }
    
    

    
    
    func requestWhenInUseAuthorization(){
        
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied {
            
            let title: String = (status == CLAuthorizationStatus.denied) ? "Location services are off" : "Background location is not enabled"
            let message: String = "To use nearby features you must turn on 'When In Use' in the Location Services Settings"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
                
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alert) in
                
                if let actualSettingsURL = URL(string: UIApplicationOpenSettingsURLString){
                    
                    UIApplication.shared.openURL(actualSettingsURL)
                    
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if status == CLAuthorizationStatus.notDetermined {
            
            self.locationManager.requestAlwaysAuthorization()
            
        } else {
            
            updateLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            
            updateLocation()
            
        }
    }

    
    @IBAction func chooseGym(_ sender: Any) {

        toggleSelectGym()
    }
    
    
    @IBAction func finish(_ sender: Any) {
        
        if cameFromFacebook {

            if let myUID = Auth.auth().currentUser?.uid {
                
               let ref = Database.database().reference().child("users").child(myUID)
                
                ref.child("myGymLongitude").setValue(self.selectedGymLong)
                ref.child("myGymLatitude").setValue(self.selectedGymLat)
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainRootController") as?  MainRootController {
                    
                    self.present(vc, animated: true, completion: {
                        
                    })
                }

                
            }
            
            
            
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
                        
                        userData["gymName"] = self.selectedGymName
                        userData["gymAddress"] = self.selectedGymAddress
                        userData["myGymLatitude"] = self.selectedGymLat
                        userData["myGymLongitude"] = self.selectedGymLong
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        self.selectGymConstOutlet.constant = self.view.bounds.height
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gymAddress.adjustsFontSizeToFitWidth = true
        
        finishButton.setTitleColor(UIColor.white, for: .normal)
        finishButton.setTitleColor(UIColor.lightGray, for: .disabled)
        
        self.buttonView.layer.cornerRadius = 3
        
        
        finishButton.isEnabled = false
        
        updateLocation()
        requestWhenInUseAuthorization()
        
        //self.selectGymConstOutlet.constant = self.view.bounds.height
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "googleGymSegue" {
            
            let nav = segue.destination as? UINavigationController
            let vc = nav?.viewControllers.first as! GoogleGymViewController
            
            gymSelectController = vc
            gymSelectController?.thirdSignUpController = self
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
