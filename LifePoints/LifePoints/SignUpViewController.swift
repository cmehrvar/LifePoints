//
//  SignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-27.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    weak var firstSignUp: firstSignUpViewController?
    weak var logInController: LogInController?
    
    @IBOutlet weak var oneThreeConst: NSLayoutConstraint!
    
    @IBAction func signIn(_ sender: Any) {
        
        logInController?.toggleSignIn(action: "close", completion: { (bool) in
            
            print("closed")
            
        })
        
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        
        toggleOneThree(direction: "open") { (bool) in
            
            
            
        }
        
    }
    
    
    
    func toggleOneThree(direction: String, completion: @escaping (Bool) -> ()){
        
        var const: CGFloat = 0
        
        if direction == "close" {
            
            const = self.view.bounds.width
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.oneThreeConst.constant = const
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
        
        if segue.identifier == "signUpOne" {
            
            let vc = segue.destination as? firstSignUpViewController
            firstSignUp = vc
            firstSignUp?.signUpController = self
            
            
        }
        
    }
    
    

}
