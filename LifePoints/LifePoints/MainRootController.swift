//
//  MainRootController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class MainRootController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var globLocation: CLLocation!
    
    var locUpdatetimer = Timer()
    var checkRangeTimer = Timer()
    
    var menuOpen = false
    
    var firstLocationUpload = false
    
    var currentTab = "profile"
    var currentBottomTab = "myRewards"
    
    weak var menuController: MenuViewController?
    weak var rewardsController: RewardsViewController?
    weak var collectController: CollectViewController?
    
    @IBOutlet weak var TableViewText: UILabel!
    
    @IBOutlet weak var ProfileXConstraint: NSLayoutConstraint!
    @IBOutlet weak var RewardsXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    @IBOutlet weak var profilePageOutlet: UIButton!
    @IBOutlet weak var rewardsPageOutlet: UIButton!
    @IBOutlet weak var collectPageOutlet: UIButton!
 
    @IBOutlet weak var myRewardsView: UIView!
    @IBOutlet weak var bottomMyRewards: UIView!
    @IBOutlet weak var myChallengesView: UIView!
    @IBOutlet weak var bottomMyChallenges: UIView!
    @IBOutlet weak var myRewardsOutlet: UIButton!
    @IBOutlet weak var myChallengesOutlet: UIButton!
    @IBOutlet weak var greyViewOutlet: UIView!
    @IBOutlet weak var menuContainerLeading: NSLayoutConstraint!
    
    @IBOutlet weak var pointsOutlet: UILabel!
    
    
    func addListeners(){

        if let uid = Auth.auth().currentUser?.uid {
            
            let pointsRef = Database.database().reference().child("users").child(uid).child("points")
            
            pointsRef.observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? Int {
                    
                    self.pointsOutlet.text = String(value)
                    
                }
            })
            
            
            
        }
    }
    
    
    func closeMenu(){
        
        toggleMenu { (bool) in
            
            print("menu closed")
            
        }
    }
    
    func addCloseMenu(){
        
        let closeMenuTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        closeMenuTapGesture.delegate = self
        greyViewOutlet.addGestureRecognizer(closeMenuTapGesture)
        
        
    }
    
    
    func toggleMenu(completion: @escaping (Bool) -> ()){
        
        var const: CGFloat = 0
        var alpha: CGFloat = 1
        
        if menuOpen {
            
            const = -(self.view.bounds.width)*0.8
            alpha = 0
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.greyViewOutlet.alpha = alpha
            self.menuContainerLeading.constant = const
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.menuOpen = !self.menuOpen
            completion(bool)
            
        }
        
    }
    
    
    //Table View Delegates
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
            
            self.TableViewText.text = "Challenges are given out on a weekly basis and expire at the end of the week, so make sure to get them done in time!"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myChallenges", for: indexPath) as! MyRewardsCell
            
            return cell
            
        }

    }
    
    
    //Actions
    @IBAction func menuButton(_ sender: Any) {
        
        self.toggleMenu { (bool) in
            
            print("menu toggled")
            
        }
    }

    
    
    @IBAction func profileSelect(_ sender: Any) {
        
        print(currentTab)
        
        let screenWidth = self.view.bounds.width
        
        UIView.animate(withDuration: 0.3, animations: {

            self.ProfileXConstraint.constant = 0
            self.RewardsXConstraint.constant = screenWidth
            
            
            self.profilePageOutlet.setImage(UIImage(named: "profileSelected"), for: .normal)
            self.collectPageOutlet.setImage(UIImage(named: "collectUnselected"), for: .normal)
            self.rewardsPageOutlet.setImage(UIImage(named: "rewardsUnselected"), for: .normal)
            
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
            
            self.profilePageOutlet.setImage(UIImage(named: "profileUnselected"), for: .normal)
            self.collectPageOutlet.setImage(UIImage(named: "collectSelected"), for: .normal)
            self.rewardsPageOutlet.setImage(UIImage(named: "rewardsUnselected"), for: .normal)

            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.currentTab = "collect"
            
        }
    }

    
    @IBAction func rewardsSelect(_ sender: Any) {
        
        print(currentTab)

            UIView.animate(withDuration: 0.3, animations: {
                
                self.RewardsXConstraint.constant = 0
                self.rewardsController?.toggleAllPartners(direction: "close", completion: { (bool) in
                    
                    print("all partners closed")
                    
                })
                
                self.rewardsController?.allPartnersController?.toggleSelectedStore(action: "close", completion: { (bool) in
                    
                    print("selected store closed")
                    
                })
                
                self.profilePageOutlet.setImage(UIImage(named: "profileUnselected"), for: .normal)
                self.collectPageOutlet.setImage(UIImage(named: "collectUnselected"), for: .normal)
                self.rewardsPageOutlet.setImage(UIImage(named: "rewardsSelected"), for: .normal)
                
                self.view.layoutIfNeeded()
                
            }) { (bool) in
                
                self.currentTab = "rewards"
                
            }
    }
    
    
    @IBAction func myRewards(_ sender: Any) {
        
        currentBottomTab = "myRewards"
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.myRewardsView.backgroundColor = UIColor.white
            self.bottomMyRewards.backgroundColor = UIColor.white
            self.myChallengesView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.bottomMyChallenges.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            
            self.myRewardsOutlet.setTitleColor(UIColor.black, for: .normal)
            self.myChallengesOutlet.setTitleColor(UIColor.white, for: .normal)
            
         
            
            
        }) 
        
        self.myTableView.reloadData()
    }
    
    

    @IBAction func myChallenges(_ sender: Any) {
        
        currentBottomTab = "myChallenges"
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.myRewardsView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.bottomMyRewards.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.myChallengesView.backgroundColor = UIColor.white
            self.bottomMyChallenges.backgroundColor = UIColor.white
            
            self.myRewardsOutlet.setTitleColor(UIColor.white, for: .normal)
            self.myChallengesOutlet.setTitleColor(UIColor.black, for: .normal)
            
            
        })
        
        self.myTableView.reloadData()
    }
    
    //Location Manager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let lastLocation = locations.last {
            
            globLocation = lastLocation
            
            if firstLocationUpload == false {
                
                firstLocationUpload = true
                updateLocationToFirebase()
                
            }
            
        }
    }
    
    //Functions
    func beginCheckingInRange(){
        
        self.locUpdatetimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkIfInRange), userInfo: nil, repeats: true)

    }
    
    
    func checkIfInRange(){
        
        if let uid = Auth.auth().currentUser?.uid {

            let latRef = Database.database().reference().child("users").child(uid).child("myGymLatitude")
            
            latRef.observe(.value, with: { (latitudeSnapshot) in
                
                let longRef = Database.database().reference().child("users").child(uid).child("myGymLongitude")
                longRef.keepSynced(true)
                
                longRef.observeSingleEvent(of: .value, with: { (longitudeSnapshot) in
                    
                    if let gymLatitude = latitudeSnapshot.value as? CLLocationDegrees, let gymLongitude = longitudeSnapshot.value as? CLLocationDegrees {
                        
                        let gymCoordinate = CLLocation(latitude: gymLatitude, longitude: gymLongitude)
                        
                        let distance = self.globLocation.distance(from: gymCoordinate)
                        
                        
                        if distance < 200 {

                            self.collectController?.collectButtonOutlet.isEnabled = true
                            self.collectController?.inRangeImage.image = UIImage(named: "inRange")
                            

                        } else {

                            self.collectController?.collectButtonOutlet.isEnabled = false
                            self.collectController?.lpCollectNumberView.alpha = 0
                            self.collectController?.collectButtonOutlet.alpha = 1
                            self.collectController?.inRangeImage.image = UIImage(named: "outOfRange")
                            self.collectController?.beginCollectingTimer.invalidate()

                        }
                    }
                })
            })
        }
    }
    

    func updateLocationToFirebase(){
        
        guard let scopeLocation = globLocation else {return}
        
        let geoCoder = CLGeocoder()
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let userRef = Database.database().reference().child("users").child(uid)
            
            userRef.updateChildValues(["latitude" : scopeLocation.coordinate.latitude, "longitude" : scopeLocation.coordinate.longitude])
            
            geoCoder.reverseGeocodeLocation(scopeLocation) { (placemark, error) in
                
                if error == nil {
                    
                    if let place = placemark?[0] {
                        
                        if let city = place.locality  {
                            
                            let replacedCity = city.replacingOccurrences(of: ".", with: "")
                            
                            userRef.updateChildValues(["city" : replacedCity])
        
                        }
                        
                        if let state = place.administrativeArea {
                            
                            userRef.updateChildValues(["state" : state])
                            
                        }
                        
                        if let country = place.country {
                            
                            userRef.updateChildValues(["country" : country])
                            
                        }
                    }
                    
                } else {
                    print(error)
                }
            }
        }
    }
    
    
    func updateLocation(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        self.locUpdatetimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateLocationToFirebase), userInfo: nil, repeats: true)
        
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
            
            self.locationManager.requestWhenInUseAuthorization()
            
        } else {
            
            updateLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            
            updateLocation()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("users").child(uid)
            ref.child("myGymLongitude").setValue(0)
            ref.child("myGymLatitude").setValue(0)
            
        }
        
        requestWhenInUseAuthorization()
        beginCheckingInRange()
        checkIfInRange()
        
        addCloseMenu()
        addListeners()

        let width = self.view.bounds.width
        self.RewardsXConstraint.constant = width
        
        self.myRewardsView.layer.cornerRadius = 10
        self.myChallengesView.layer.cornerRadius = 10

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "menuSegue" {
            
            let menu = segue.destination as? MenuViewController
            menuController = menu
            menuController?.mainRoot = self
            
        } else if segue.identifier == "rewardsSegue" {
            
            let rewards = segue.destination as? RewardsViewController
            rewardsController = rewards
            rewardsController?.mainRoot = self
            
            
        } else if segue.identifier == "collectSegue" {
            
            let collect = segue.destination as? CollectViewController
            collectController = collect
            collectController?.mainRootController = self
            
        }
    }
}
