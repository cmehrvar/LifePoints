//
//  ViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit

class LogInController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var DismissKeyboard: UIView!
    @IBOutlet weak var UsernameView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissTap.delegate = self
        DismissKeyboard.addGestureRecognizer(dismissTap)
        
        self.UsernameView.layer.cornerRadius = 10
        self.PasswordView.layer.cornerRadius = 10
        
        
    }
    
    func dismissKeyboard(){
        
        self.view.endEditing(true)
        
    }
    
    func keyboardDidShow() {
        
        DismissKeyboard.alpha = 1
        
        if UsernameTextField.text == "Username" {
            
            UsernameTextField.text = nil
            
        }

    }
    
    func keyboardDidHide() {
        
        DismissKeyboard.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

