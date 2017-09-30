//
//  RewardsViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase

class RewardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    weak var mainRoot: MainRootController?
    weak var selectedStoreController: SelectedStoreViewController?

    @IBOutlet weak var selectedStoreConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var LtoRsliderImage: UIImageView!
    @IBOutlet weak var FixedImage: UIImageView!
    @IBOutlet weak var RtoLslider: UIImageView!

    @IBOutlet weak var LtoRcenterConst: NSLayoutConstraint!
    @IBOutlet weak var RtoLcenterConst: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var imageSlider: UIView!
    
    var slidingTimer = Timer()

    var imagePromoPosition = 0
    var imagePromo = [String]()
    var partnerNames = [String]()
    var partnerLogos = [String]()
    var partnerUIDs = [String]()
    

    func loadImagePromo() {
        
        guard let first = imagePromo.first, let url = URL(string: first) else {return}
        
        print(first)
        
        FixedImage.sd_setImage(with: url)
        imagePromoPosition = 0
        
    }
    
    
    func slidefromLeftToRight(){
        
        if imagePromoPosition > 0 {
            
            imagePromoPosition -= 1
            
            let lastImage = imagePromo[imagePromoPosition]
            
            guard let url = URL(string: lastImage) else {return}
                
            LtoRsliderImage.sd_setImage(with: url)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.LtoRcenterConst.constant = 0
                self.view.layoutIfNeeded()
                
            }, completion: { (bool) in
                
                self.FixedImage.sd_setImage(with: url)
                self.LtoRsliderImage.image = nil
                self.LtoRcenterConst.constant = -self.view.bounds.width
                
                
            })
            
        } else if imagePromoPosition == 0 {
            
            imagePromoPosition = imagePromo.count - 1
            
            let lastImage = imagePromo[imagePromoPosition]
            
            guard let url = URL(string: lastImage) else {return}
            
            LtoRsliderImage.sd_setImage(with: url)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.LtoRcenterConst.constant = 0
                self.view.layoutIfNeeded()
                
            }, completion: { (bool) in
                
                self.FixedImage.sd_setImage(with: url)
                self.LtoRsliderImage.image = nil
                self.LtoRcenterConst.constant = -self.view.bounds.width
                
                
            })

        }
        
    }
    
    func slideFromRightToLeft(){
        
        if imagePromo.count > 0 {
            
            if imagePromoPosition < imagePromo.count - 1 {
                
                imagePromoPosition += 1
                
                let nextImage = imagePromo[imagePromoPosition]
                
                guard let url = URL(string: nextImage) else {return}
                
                RtoLslider.sd_setImage(with: url)
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.RtoLcenterConst.constant = 0
                    self.view.layoutIfNeeded()
                    
                }, completion: { (bool) in
                    
                    self.FixedImage.sd_setImage(with: url)
                    self.RtoLslider.image = nil
                    self.RtoLcenterConst.constant = self.view.bounds.width
                    
                    
                })
                
            } else if imagePromoPosition == imagePromo.count - 1 {
                
                imagePromoPosition = 0
                
                let nextImage = imagePromo[imagePromoPosition]
                
                guard let url = URL(string: nextImage) else {return}
                
                RtoLslider.sd_setImage(with: url)
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.RtoLcenterConst.constant = 0
                    self.view.layoutIfNeeded()
                    
                }, completion: { (bool) in
                    
                    self.FixedImage.sd_setImage(with: url)
                    self.RtoLslider.image = nil
                    self.RtoLcenterConst.constant = self.view.bounds.width
                    
                    
                })
            }

            
            
        }
        
            }

    func toggleSelectedStore(direction: String, completion: @escaping (Bool) -> ()){
        
        let width = self.view.bounds.width
        
        
        
        if direction == "open" {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.selectedStoreConstraint.constant = 0
                self.view.layoutIfNeeded()
                
            }, completion: { (bool) in
                
                completion(bool)
                
            })
            
        } else if direction == "close" {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.selectedStoreConstraint.constant = width
                self.view.layoutIfNeeded()
                
            }, completion: { (bool) in
                
                self.selectedStoreController?.rewardUIDs.removeAll()
                self.selectedStoreController?.rewardDescriptions.removeAll()
                self.selectedStoreController?.rewardPoints.removeAll()
                self.selectedStoreController?.myTableView.reloadData()

                
                completion(bool)
                
            })
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.bounds.width
        
        return CGSize(width: width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return partnerNames.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "partner", for: indexPath) as! PartnerCollectionCell
        
        cell.buisinessUID = partnerUIDs[indexPath.row]
        
        
        if let logoURL = URL(string: partnerLogos[indexPath.row]){
            
            cell.logo.sd_setImage(with: logoURL)
            
        }

        cell.name.text = partnerNames[indexPath.row]
        
        cell.rewardsController = self
        
        return cell
        
    }


    override func viewDidAppear(_ animated: Bool) {
        
        let width = self.view.bounds.width
        selectedStoreConstraint.constant = width
        
        
    }
    
    func loadImages(){
        
        let ref = Database.database().reference().child("Partners")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String : AnyObject] {
                
                for (key, value) in data {
                    
                    
                    
                    if let valueDict = value as? [String : Any], let logo = valueDict["Logo"] as? String, let name =  valueDict["Name"] as? String {
                        
                        self.partnerUIDs.append(key)
                        
                        self.partnerLogos.append(logo)
                        
                        self.partnerNames.append(name)
                        
                        
                        
                    }
                    
                    if let valueDict = value as? [String : Any], let topPromo = valueDict["TopPromo"] as? String {
                        
                        self.imagePromo.append(topPromo)
                        
                        
                    }
                    
                    
                }
                
                self.loadImagePromo()
                self.slidingTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.slideFromRightToLeft), userInfo: nil, repeats: true)
                
                print(self.partnerNames)
                print(self.partnerLogos)
                print(self.imagePromo)
                
                self.collectionView.reloadData()

            }
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImages()
        
        
        
        let leftPromoSwipe = UISwipeGestureRecognizer(target: self, action: #selector(slideFromRightToLeft))
        leftPromoSwipe.direction = .left
        leftPromoSwipe.delegate = self
        imageSlider.addGestureRecognizer(leftPromoSwipe)
        
        let rightPromoSwipe = UISwipeGestureRecognizer(target: self, action: #selector(slidefromLeftToRight))
        rightPromoSwipe.direction = .right
        rightPromoSwipe.delegate = self
        imageSlider.addGestureRecognizer(rightPromoSwipe)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "selectedStore" {
            
            let selectedStore = segue.destination as? SelectedStoreViewController
            selectedStoreController = selectedStore
            selectedStoreController?.rewardsViewController = self
            
        }
        
    }
    

}
