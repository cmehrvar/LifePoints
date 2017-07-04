//
//  AllPartnersViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-21.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class AllPartnersViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var rewardsController: RewardsViewController?
    weak var selectedStoreController: SelectedStoreViewController?
    
    @IBOutlet weak var selectedStoreXConstraint: NSLayoutConstraint!
    
    
    
    @IBAction func backButton(_ sender: Any) {
        
        rewardsController?.toggleAllPartners(direction: "close", completion: { (bool) in
            
            print("all partners closed")
            
        })
        
    }
    
    
    func toggleSelectedStore(action: String, completion: @escaping (Bool) -> ()) {

        var width: CGFloat = 0
        
       if action == "close" {
            
            width = self.view.bounds.width
            
        }
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.selectedStoreXConstraint.constant = width
            self.view.layoutIfNeeded()
            
            
        }) { (bool) in
            
            completion(bool)
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.bounds.width
        
        return CGSize(width: width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "partner", for: indexPath) as! AllPartnersCollectionCell
        
        cell.allPartnersController = self
        
        return cell
        
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
        
        if segue.identifier == "selectedStore" {
            
            let selectedStore = segue.destination as? SelectedStoreViewController
            selectedStoreController = selectedStore
            selectedStoreController?.allPartnersViewController = self
            
        }
        
        
    }
    

}
