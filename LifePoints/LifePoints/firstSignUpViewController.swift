//
//  firstSignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-28.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class firstSignUpViewController: UIViewController, UIGestureRecognizerDelegate {

    weak var signUpController: SignUpViewController?
    weak var secondSignUp: secondSignUpViewController?
    
    
    @IBOutlet weak var secondSignUpConst: NSLayoutConstraint!
    @IBOutlet weak var usernameOutlet: UIView!
    @IBOutlet weak var passwordOutlet: UIView!
    @IBOutlet weak var retypePasswordOutlet: UIView!
    @IBOutlet weak var usernameTextOutlet: UITextField!
    @IBOutlet weak var passwordTextOutlet: UITextField!
    @IBOutlet weak var retypePasswordText: UITextField!
    @IBOutlet weak var dismissKeyboard: UIView!
    
    
    
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
    
    func keyboardDidShow(){
        
        self.dismissKeyboard.alpha = 1
        
    }
    
    func keyboardDidHide(){
        
        self.dismissKeyboard.alpha = 0
        
    }
    
    func closeKeyboard(){
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGestureRecognizer.delegate = self
        self.dismissKeyboard.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        usernameOutlet.layer.cornerRadius = 5
        passwordOutlet.layer.cornerRadius = 5
        retypePasswordOutlet.layer.cornerRadius = 5
        
        usernameTextOutlet.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTextOutlet.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        retypePasswordText.attributedPlaceholder = NSAttributedString(string: "Re-Type Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        

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
