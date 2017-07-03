//
//  RewardsViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var mainRoot: MainRootController?
    weak var allPartnersController: AllPartnersViewController?
    
    @IBOutlet weak var allPartnerXConstraint: NSLayoutConstraint!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var identifier = ""
        
        if indexPath.row % 2 == 0 {
            
            identifier = "CategoryLeft"
            
        } else {
            
            identifier = "CategoryRight"
            
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCollectionViewCell
        
        
        if indexPath.row == 0 {
            
            cell.supplementsImage.image = UIImage(named: "Supplements")
            cell.supplementsLabel.text = "Supplements"
            
        } else if indexPath.row == 1 {
            
            cell.supplementsImage.image = UIImage(named: "Clothes")
            cell.supplementsLabel.text = "Clothing"
            
        } else if indexPath.row == 2 {
            
            cell.supplementsImage.image = UIImage(named: "Groceries")
            cell.supplementsLabel.text = "Groceries"
            
            
        } else if indexPath.row == 3 {
            
            cell.supplementsImage.image = UIImage(named: "Food")
            cell.supplementsLabel.text = "Restaurants"
            
        }
        
    
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let length = (self.view.bounds.width/2)
        return CGSize(width: length, height: length)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AllPartners", for: indexPath) as! HeaderCollectionReusableView
        
        view.rewardsViewController = self
        
        return view
        
    }
    
    
    func toggleAllPartners(direction: String, completion: @escaping (Bool) -> ()){
        
        let width = self.view.bounds.width
        
        if direction == "open" {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.allPartnerXConstraint.constant = 0
                self.view.layoutIfNeeded()
                
            }, completion: { (bool) in
                
                completion(bool)
                
            })
            
        } else if direction == "close" {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.allPartnerXConstraint.constant = width
                self.view.layoutIfNeeded()
                
            }, completion: { (bool) in
                
                completion(bool)
                
            })
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let height = self.view.bounds.height
        allPartnerXConstraint.constant = height
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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
        
        if segue.identifier == "allPartners" {
            
            let allPartners = segue.destination as? AllPartnersViewController
            allPartnersController = allPartners
            allPartnersController?.rewardsController = self
            
        }
        
    }
    

}
