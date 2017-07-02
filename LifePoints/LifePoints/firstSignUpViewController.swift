//
//  firstSignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-28.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class firstSignUpViewController: UIViewController {

    weak var signUpController: SignUpViewController?
    weak var secondSignUp: secondSignUpViewController?
    
    
    @IBOutlet weak var secondSignUpConst: NSLayoutConstraint!
    
    
    @IBAction func next(_ sender: Any) {
        
        toggleSignUpTwo(direction: "open") { (bool) in
            
            print("signUpTwo opened")
            
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        signUpController?.toggleOneThree(direction: "close", completion: { (bool) in
            
            print("first closed")
            
        })
        
    }
    
    
    func toggleSignUpTwo(direction: String, completion: @escaping (Bool) -> ()) {
        
        var const: CGFloat = 0
        
        if direction == "close" {
        
            const = self.view.bounds.width
        
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.secondSignUpConst.constant = const
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            completion(bool)
            
        }
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
        
        if segue.identifier == "signUpTwo" {
            
            let vc = segue.destination as? secondSignUpViewController
            secondSignUp = vc
            secondSignUp?.firstSignUp = self

        }
        
    }
    

}
