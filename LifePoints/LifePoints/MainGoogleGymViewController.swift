//
//  MainGoogleGymViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-09-26.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class MainGoogleGymViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    weak var mainRootController: MainRootController?
    
    var gymNames = [String]()
    var gymAddresses = [String]()
    var gymLongitudes = [CLLocationDegrees]()
    var gymLatitudes = [CLLocationDegrees]()
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y < 0.0 {
            
            view.endEditing(true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let myUID = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("users").child(myUID)
            
            ref.child("gymName").setValue(gymNames[indexPath.row])
            ref.child("gymAddress").setValue(gymAddresses[indexPath.row])
            ref.child("myGymLatitude").setValue(gymLatitudes[indexPath.row])
            ref.child("myGymLongitude").setValue(gymLongitudes[indexPath.row])
            
            
            
        }
        
        mainRootController?.profileController?.loadPage()
        
        mainRootController?.toggleMainGym()

        self.view.endEditing(true)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gymNames.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "anotherGoogleGym", for: indexPath) as! GoogleGymTableViewCell
        
        cell.placeOutlet.text = gymNames[indexPath.row]
        cell.locationOutlet.text = gymAddresses[indexPath.row]
        
        return cell
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        
        var urlString = ""
        
        if let myLocation = mainRootController?.globLocation {
            
            let myLatitude = myLocation.coordinate.latitude
            let myLongitude = myLocation.coordinate.longitude
            
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(myLatitude),\(myLongitude)&radius=20000&type=gym&key=AIzaSyD1bcUx_sPrm3UJSFc8fGjkUrEOhdT8tJM&name=\(searchText)&keyword=\(searchText)"
            
            
        } else {
            
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=43.656473,-79.377015&radius=50000&type=gym&key=AIzaSyD1bcUx_sPrm3UJSFc8fGjkUrEOhdT8tJM&name=\(searchText)"
            
            
        }
        
        
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in

            DispatchQueue.main.async {
                
                self.gymNames.removeAll()
                self.gymAddresses.removeAll()
                self.gymLongitudes.removeAll()
                self.gymLatitudes.removeAll()
                
                if error == nil {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        if let data1 = json as? [AnyHashable : Any] {
                            
                            for (key1, values1) in data1 {
                                
                                if let data2 = values1 as? [Any] {
                                    
                                    print(data2)
                                    
                                    for (value) in data2 {
                                        
                                        if let data3 = value as? [AnyHashable:Any] {
                                            
                                            for (someKey, someValue) in data3 {
                                                
                                                print(someKey)
                                                print(someValue)
                                                
                                            }
                                            
                                            if let name = data3["name"] as? String, let address = data3["vicinity"] as? String, let geometry = data3["geometry"] as? [AnyHashable : Any], let location = geometry["location"] as? [AnyHashable:Any], let latitude = location["lat"] as? CLLocationDegrees, let longitude = location["lng"] as? CLLocationDegrees {
                                                
                                                self.gymLatitudes.append(latitude)
                                                self.gymLongitudes.append(longitude)
                                                self.gymNames.append(name)
                                                self.gymAddresses.append(address)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
                            self.myTableView.reloadData()
                        }
                        
                    } catch let error {
                        
                        print(error)
                        
                    }
                    
                } else {
                    
                    print(error)
                    
                }
            }
        }
        
        task.resume()

        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text {
            
            
            
        }
        
    }

    
    @IBAction func Cancel(_ sender: Any) {
        
        self.view.endEditing(true)
        
        mainRootController?.toggleMainGym()
        
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
