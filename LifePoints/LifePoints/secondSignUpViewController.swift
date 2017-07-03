//
//  secondSignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-28.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class secondSignUpViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var thirdSignUpConst: NSLayoutConstraint!
    

    weak var thirdSignUp: ThirdSignUpViewController?
    weak var firstSignUp: firstSignUpViewController?
    
    @IBOutlet weak var firstNameViewOutlet: UIView!
    @IBOutlet weak var lastNameViewOutlet: UIView!
    @IBOutlet weak var emailViewOutlet: UIView!
    @IBOutlet weak var firstNameTextOutlet: UITextField!
    @IBOutlet weak var lastNameTextOutlet: UITextField!
    @IBOutlet weak var emailTextOutlet: UITextField!
    @IBOutlet weak var dismissKeyboardView: UIView!
    
    
    
    
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
    
    func closeKeyboard(){
        
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func signIn(_ sender: Any) {
    }
    
    func keyboardDidShow(){
        
        self.dismissKeyboardView.alpha = 1
        
    }
    
    func keyboardDidHide(){
        
        self.dismissKeyboardView.alpha = 0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGestureRecognizer.delegate = self
        self.dismissKeyboardView.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

        ageView.layer.cornerRadius = 5
        firstNameViewOutlet.layer.cornerRadius = 5
        lastNameViewOutlet.layer.cornerRadius = 5
        emailViewOutlet.layer.cornerRadius = 5
        
        firstNameTextOutlet.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        lastNameTextOutlet.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        emailTextOutlet.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
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
