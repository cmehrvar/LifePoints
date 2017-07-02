//
//  secondSignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-28.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class secondSignUpViewController: UIViewController {
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var thirdSignUpConst: NSLayoutConstraint!
    

    weak var thirdSignUp: ThirdSignUpViewController?
    weak var firstSignUp: firstSignUpViewController?
    
    @IBAction func next(_ sender: Any) {
        
        toggleThree(direction: "open") { (bool) in
            
            
            
        }
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        firstSignUp?.toggleSignUpTwo(direction: "close", completion: { (bool) in
            
            
            
        })
        
    }
    
    
    func toggleThree(direction: String, completion: @escaping (Bool) -> ()) {
        
        var const: CGFloat = 0
        
        if direction == "close" {
            
            const = self.view.bounds.width
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.thirdSignUpConst.constant = const
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            completion(bool)
            
        }
    }
    
    
    
    @IBAction func signIn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ageView.layer.cornerRadius = 5
        
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
        
        if segue.identifier == "signUpThree" {
            
            let vc = segue.destination as? ThirdSignUpViewController
            thirdSignUp = vc
            thirdSignUp?.signUpTwo = self
            
            
        }
        
    }
    

}
