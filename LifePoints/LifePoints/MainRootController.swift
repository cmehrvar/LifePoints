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
    @IBOutlet weak var redemptionView: UIView!

    let locationManager = CLLocationManager()
    var globLocation: CLLocation!
    
    var locUpdatetimer = Timer()
    var checkRangeTimer = Timer()
    
    
    var mainGymOpen = false
    
    
    var menuOpen = false
    
    var historyOpen = false
    
    var firstLocationUpload = false
    
    var currentTab = "profile"
    var currentBottomTab = "myRewards"
    
    var rewardTitleToRedeem = ""
    var rewardPointsToRedeem = 0
    var rewardPartnerToRedeem = ""
    var rewardUIDtoRedeem = ""
    
    weak var googleGymController: MainGoogleGymViewController?
    weak var menuController: MenuViewController?
    weak var rewardsController: RewardsViewController?
    weak var collectController: CollectViewController?
    weak var historyController: HistoryViewController?
    weak var profileController: ProfileViewController?
    
    
    @IBOutlet weak var comingSoonView: UIView!

    @IBOutlet weak var gymSelectConst: NSLayoutConstraint!

    @IBOutlet weak var TableViewText: UILabel!
    
    @IBOutlet weak var ProfileXConstraint: NSLayoutConstraint!
    @IBOutlet weak var RewardsXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var googleSelectGym: UIView!
    
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
    @IBOutlet weak var redeemViewOutlet: UIView!
    @IBOutlet weak var blurViewOutletj: UIVisualEffectView!
    
    @IBOutlet weak var redemptionDescriptionOutlet: UILabel!
    @IBOutlet weak var partnerDescriptionOutlet: UILabel!
    
    @IBOutlet weak var redemptionSliderOutlet: UIImageView!
    
    
    
    @IBOutlet weak var redemptionSliderViewOutlet: UIView!
    
    
    @IBOutlet weak var redemptionSliderConstOutlet: NSLayoutConstraint!
    
    
    @IBOutlet weak var redemptionSliderWidthOutlet: UIView!

    @IBOutlet weak var historyContainerConstOutlet: NSLayoutConstraint!
    
    
    @IBOutlet weak var pointsOutlet: UILabel!
    
    
    var challengeUIDs = [String]()
    var challengePoints = [Int]()
    var challengeDescriptions = [String]()
    var challengeObtainValue = [Int]()
    var challengeObtainUnit = [String]()
    
    
    var rewardUIDs = [String]()
    var rewardPartners = [String]()
    var rewardPoints = [Int]()
    var rewardDescriptions = [String]()
    

    func toggleMainGym(){
        
        var const: CGFloat = 0
        
        if mainGymOpen == true {
            
            const = self.view.bounds.height
            
        }

        UIView.animate(withDuration: 0.3, animations: {
            
            self.gymSelectConst.constant = const
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            self.mainGymOpen = !self.mainGymOpen

        }
    }
    
    
    
    @IBAction func redemptionCancel(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.redeemViewOutlet.alpha = 0
            self.blurViewOutletj.alpha = 0
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            print("redemption closed")
            
        }
    }
    
    func loadChallenges() {
        
        let ref = Database.database().reference().child("Challenges")
        
        ref.keepSynced(true)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String : Any] {
                
                self.challengeUIDs.removeAll()
                self.challengePoints.removeAll()
                self.challengeDescriptions.removeAll()
                self.challengeObtainUnit.removeAll()
                self.challengeObtainValue.removeAll()
                
                for (key, value) in data {
                    
                    if let dictValue = value as? [String : Any] {
                        
                        if let points = dictValue["points"] as? Int, let obtainValue = dictValue["obtainValue"] as? Int, let someDescription = dictValue["description"] as? String, let obtainUnit = dictValue["obtainUnit"] as? String {
                            
                            self.challengeUIDs.append(key)
                            
                            self.challengePoints.append(points)
                            self.challengeDescriptions.append(someDescription)
                            self.challengeObtainUnit.append(obtainUnit)
                            self.challengeObtainValue.append(obtainValue)

                            
                            
                        }
                    }
                }
                
                self.myTableView.reloadData()
                
            }
            
        })
        
    }
    
    
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
    
    
    func toggleHistory(action: String, completion: @escaping (Bool) -> ()){
        
        var const: CGFloat = 0
        
        if action == "close" {
            
            let width = self.view.bounds.width
            const = -width
            
            historyController?.history.removeAll()
            historyController?.myTableView.reloadData()
            
            //clear history

        } else {
            
            historyController?.loadHistory()
            
        }

        UIView.animate(withDuration: 0.3, animations: {
            
            self.historyContainerConstOutlet.constant = const
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            
            completion(bool)
            
        }
        
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
        
        if currentBottomTab == "myRewards" {
            
            return rewardUIDs.count
            
        } else {
            
            return challengeUIDs.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.allowsSelection = false
        
        if currentBottomTab == "myRewards" {
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myRewards", for: indexPath) as! MyRewardsCell
            
            cell.partner = rewardPartners[indexPath.row]
            cell.title = rewardDescriptions[indexPath.row]
            cell.points = rewardPoints[indexPath.row]
            
            cell.partnerName.text = rewardPartners[indexPath.row]
            cell.descriptionOutlet.text = rewardDescriptions[indexPath.row]
            cell.rewardUID = rewardUIDs[indexPath.row]
            
            cell.mainrootcontroller = self
            
            return cell
            
        } else {
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myChallenges", for: indexPath) as! MyChallengesTableViewCell
            
            cell.descriptionOutlet.text = challengeDescriptions[indexPath.row]

            cell.pointsOutlet.text = challengePoints[indexPath.row].description
            cell.obtainValueOutlet.text = challengeObtainValue[indexPath.row].description
            cell.obtainUnitOutlet.text = " " + challengeObtainUnit[indexPath.row]
            
            return cell
            
        }

    }
    
    
    //Actions
    @IBAction func menuButton(_ sender: Any) {
        
        self.toggleMenu { (bool) in
            
            print("menu toggled")
            
        }
    }
    
    
    func loadRewardsInfo(){

        if let myUID = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("users").child(myUID).child("myrewards")
            
            ref.keepSynced(true)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let data = snapshot.value as? [String : Any] {
                    
                    self.rewardUIDs.removeAll()
                    self.rewardPoints.removeAll()
                    self.rewardDescriptions.removeAll()
                    self.rewardPartners.removeAll()
                    
                    for (key,value) in data {
                        
                        if let dictvalue = value as? [String : Any] {
                            
                            if let someDescription = dictvalue["description"] as? String, let someName = dictvalue["name"] as? String, let somePoints = dictvalue["points"] as? Int {
              
                                self.rewardUIDs.append(key)
                                self.rewardPoints.append(somePoints)
                                self.rewardDescriptions.append(someDescription)
                                self.rewardPartners.append(someName)
                                
                            }
                        }
                    }
                    
                    self.myTableView.reloadData()

                } else {
                    
                    self.rewardUIDs.removeAll()
                    self.rewardPoints.removeAll()
                    self.rewardDescriptions.removeAll()
                    self.rewardPartners.removeAll()
                    
                    self.myTableView.reloadData()
                    
                }
            })
        }
    }

    
    
    @IBAction func profileSelect(_ sender: Any) {
        
        loadRewardsInfo()
        
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
        
        loadRewardsInfo()
        
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
        
        rewardsController?.loadImages()

            UIView.animate(withDuration: 0.3, animations: {
                
                self.RewardsXConstraint.constant = 0
                self.rewardsController?.toggleSelectedStore(direction: "close", completion: { (bool) in
                    
                    print("all partners closed")
                    
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
        
        self.TableViewText.text = "Click on the reward you would like to redeem and follow the instructions in the presence of the store cashier."
        
        self.comingSoonView.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.myRewardsView.backgroundColor = UIColor.white
            self.bottomMyRewards.backgroundColor = UIColor.white
            self.myChallengesView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.bottomMyChallenges.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            
            self.myRewardsOutlet.setTitleColor(UIColor.black, for: .normal)
            self.myChallengesOutlet.setTitleColor(UIColor.white, for: .normal)
            
         
            self.view.layoutIfNeeded()
            
        }) 
        
        self.myTableView.reloadData()
    }
    
    

    @IBAction func myChallenges(_ sender: Any) {
        
        
        
        currentBottomTab = "myChallenges"
        
        self.TableViewText.text = "Challenges are given out on a weekly basis and expire at the end of the week, so make sure to get them done in time!"
        
        loadChallenges()
        
        self.comingSoonView.alpha = 1
        
        UIView.animate(withDuration: 0.3, animations: {
            
            
            
            self.myRewardsView.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.bottomMyRewards.backgroundColor = self.hexStringToUIColor(hex: "A29DCB")
            self.myChallengesView.backgroundColor = UIColor.white
            self.bottomMyChallenges.backgroundColor = UIColor.white
            
            self.myRewardsOutlet.setTitleColor(UIColor.white, for: .normal)
            self.myChallengesOutlet.setTitleColor(UIColor.black, for: .normal)
            
            self.view.layoutIfNeeded()
            
        })
    }
    
    //Location Manager Delegates
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        checkIfInRange()
        
        let currentDate = NSDate().timeIntervalSince1970
        
        if let reference = self.collectController?.referenceDate, let collecting = self.collectController?.collecting {
            
            if collecting {
                
                if let pointsCollected = self.collectController?.pointsCollectedToday {
                    
                    if pointsCollected < 1000 {
                        
                        self.collectController?.dailyLimitOutlet.alpha = 0
                        
                        if currentDate-reference > 7.2 {
                            
                            self.collectController?.referenceDate = Date().timeIntervalSince1970
                            self.collectController?.updateLifePoints()
                            
                        }
                        
                    } else {
                        
                        self.collectController?.dailyLimitOutlet.alpha = 1
                        
                    }
                }
            }
        }

        
        if let lastLocation = locations.last {
            
            globLocation = lastLocation
            
            if firstLocationUpload == false {
                
                firstLocationUpload = true
                updateLocationToFirebase()
                
            }
            
        }
    }
    
    //Functions
    func checkIfInRange(){
        
        if let uid = Auth.auth().currentUser?.uid {

            let ref = Database.database().reference().child("users").child(uid)
            
            ref.keepSynced(true)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let data = snapshot.value as? [AnyHashable:Any] {
                    
                    if let gymLatitude = data["myGymLatitude"] as? CLLocationDegrees, let gymLongitude = data["myGymLongitude"] as? CLLocationDegrees {
                        
                        let gymCoordinate = CLLocation(latitude: gymLatitude, longitude: gymLongitude)
                        
                        guard let myLocation = self.globLocation else {return}
                        
                        let distance = myLocation.distance(from: gymCoordinate)
                        
                        if distance < 50 {
                            
                            self.collectController?.collectButtonOutlet.isEnabled = true
                            self.collectController?.inRangeImage.image = UIImage(named: "inRange")
                            
                            
                        } else {
                            
                            self.collectController?.collectButtonOutlet.isEnabled = false
                            self.collectController?.lpCollectNumberView.alpha = 0
                            self.collectController?.collectButtonOutlet.alpha = 1
                            self.collectController?.inRangeImage.image = UIImage(named: "outOfRange")
                            
                            self.collectController?.dailyLimitOutlet.alpha = 0
                            
                            self.collectController?.collecting = false
                            
                        }
                    }

                }
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
    

    
    
    func redemptionSlider(recognizer: UIPanGestureRecognizer){
        
        let translation = recognizer.translation(in: self.view).x
        
        
        
        if translation > 0 && translation < redemptionSliderWidthOutlet.bounds.width {
            
            redemptionSliderConstOutlet.constant = translation
            
        }
        
        
        
        switch recognizer.state {
            
        case .began:
            print("began")
            
        case .ended:
            print("ended")
            
            if recognizer.velocity(in: self.view).x > 750 {
                
                if let uid = Auth.auth().currentUser?.uid {
                    
                    let ref = Database.database().reference().child("users").child(uid)
                    
                    let date = NSDate().timeIntervalSince1970
                    
                    var rewardHistory = [String:Any]()
                    
                    rewardHistory["date"] = date
                    rewardHistory["title"] = rewardTitleToRedeem
                    rewardHistory["points"] = rewardPointsToRedeem
                    rewardHistory["partner"] = rewardPartnerToRedeem
                    
                    ref.child("myrewards").child(rewardUIDtoRedeem).removeValue()
                    
                    ref.child("rewardsHistory").childByAutoId().setValue(rewardHistory)
                    
                    self.loadRewardsInfo()
                    
                }

                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.redemptionSliderConstOutlet.constant = self.redemptionSliderWidthOutlet.bounds.width-50
                    self.view.layoutIfNeeded()
                    
                }, completion: { (bool) in
                    
                    print("back to normal")
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        self.redeemViewOutlet.alpha = 0
                        self.blurViewOutletj.alpha = 0
                        self.view.layoutIfNeeded()
                        
                    }, completion: { (bool) in
                        
                        print("")
                        
                    })
                    
                    
                })

                
            } else {
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.redemptionSliderConstOutlet.constant = 2
                    self.view.layoutIfNeeded()
                    
                }, completion: { (bool) in
                    
                    print("back to normal")
                    
                })
                
            }
            
            
        case .changed:
            print("changed")
            
        default:
            break
            
            
        }
        
        
        print(translation)
        print(recognizer.velocity(in: self.view).x)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        self.gymSelectConst.constant = self.view.bounds.height
        googleSelectGym.alpha = 1
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startUpdatingLocation()
        
        self.partnerDescriptionOutlet.adjustsFontSizeToFitWidth = true
        self.redemptionDescriptionOutlet.adjustsFontSizeToFitWidth = true
        
        redemptionView.layer.cornerRadius = 20
        
        loadRewardsInfo()
        
        requestWhenInUseAuthorization()
        
        checkIfInRange()
        
        let sliderPanGesture = UIPanGestureRecognizer(target: self, action: #selector(redemptionSlider))
        sliderPanGesture.delegate = self
        redemptionSliderViewOutlet.addGestureRecognizer(sliderPanGesture)
        redemptionSliderViewOutlet.addGestureRecognizer(sliderPanGesture)

        
        addCloseMenu()
        addListeners()

        let width = self.view.bounds.width
        self.RewardsXConstraint.constant = width
        self.historyContainerConstOutlet.constant = -width
        
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
            
        } else if segue.identifier == "historySegue" {
            
            let history = segue.destination as? HistoryViewController
            historyController = history
            historyController?.mainRootController = self

        } else if segue.identifier == "mainGymSegue" {
            
            let nav = segue.destination as? UINavigationController
            let vc = nav?.viewControllers.first as? MainGoogleGymViewController
            googleGymController = vc
            googleGymController?.mainRootController = self
 
        } else if segue.identifier == "profileSegue" {
            
            let profile = segue.destination as? ProfileViewController
            profileController = profile
            profileController?.rootController = self
            
        }
    }
}
