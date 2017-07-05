//
//  firstSignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-28.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import Firebase


class firstSignUpViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    weak var logIn: LogInController?
    weak var secondSignUp: secondSignUpViewController?
    
    
    @IBOutlet weak var secondSignUpConst: NSLayoutConstraint!
    @IBOutlet weak var usernameOutlet: UIView!
    @IBOutlet weak var passwordOutlet: UIView!
    @IBOutlet weak var retypePasswordOutlet: UIView!
    @IBOutlet weak var usernameTextOutlet: UITextField!
    @IBOutlet weak var passwordTextOutlet: UITextField!
    @IBOutlet weak var retypePasswordText: UITextField!
    @IBOutlet weak var dismissKeyboard: UIView!
    
    @IBOutlet weak var emailChecker: UIImageView!
    @IBOutlet weak var passwordChecker: UIImageView!
    @IBOutlet weak var retypePasswordChecker: UIImageView!
    
    
    var emailValid: Bool = false
    var passwordValid: Bool = false
    var retypeValid: Bool = false
    
    @IBAction func next(_ sender: Any) {
        
        toggleSignUpTwo(direction: "open") { (bool) in
            
            print("signUpTwo opened")
            
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        logIn?.toggleSignIn(action: "close", completion: { (bool) in
            
            
            
        })
        
    }
    
    
    func checkEmailValid(textField: UITextField) {
        
        if let emailToCheck = textField.text {
            
            if isValidEmail(testStr: emailToCheck) {
                
                //IF IS VALID EMAIL, CHECK TO SEE IF TAKEN, ELSE GOOD EMAIL
                
                checkIfTaken(key: "takenEmails", credential: emailToCheck, completion: { (taken) in
                    
                    if taken {
                        
                        self.emailChecker.image = UIImage(named: "RedX")
                        
                        let alertController = UIAlertController(title: "Whoops", message: "Email is already taken", preferredStyle:  UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                            
                            self.usernameTextOutlet.becomeFirstResponder()
                            
                            
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        self.emailValid = false
                        
                    } else {
                        
                        self.emailChecker.image = UIImage(named: "Checkmark")
                        
                        self.emailValid = true
                        
                    }
                })
                
                
            } else {
                
                emailChecker.image = UIImage(named: "RedX")
                
                let alertController = UIAlertController(title: "Hey", message: "Please Enter a Valid Email", preferredStyle:  UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                    
                    self.usernameTextOutlet.becomeFirstResponder()
                    
                    
                }))
                
                self.present(alertController, animated: true, completion: nil)
                
                self.emailValid = false
                
                print("Bad Email")
                
            }
        }
    }
    func isValidEmail(testStr: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    
    func checkPasswordValid(textField: UITextField) {
        
        if textField.text == "" {
            
            passwordValid = false
            return
            
        }
        
        
        if let passwordToCheck = textField.text {
            
            if passwordToCheck.characters.count < 6 {
                
                passwordChecker.image = UIImage(named: "RedX")
                
                let alertController = UIAlertController(title: "Hey", message: "Password must be at least 6 characters", preferredStyle:  UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                    
                    self.passwordTextOutlet.becomeFirstResponder()
                    
                    
                }))
                
                self.present(alertController, animated: true, completion: nil)
                
                passwordValid = false
                
            } else {
                
                passwordValid = true
                
                passwordChecker.image = UIImage(named: "Checkmark")
                
            }
        }
    }
    
    func checkIfTaken(key: String, credential: String, completion: @escaping (_ taken: Bool) -> ()) {
        
        var taken = false
        
        let ref = Database.database().reference()
        ref.keepSynced(true)
        
        ref.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value)
            
            if let values = snapshot.value as? [String : String] {
                
                for (_, value) in values  {
                    
                    if credential == value {
                        
                        taken = true
                        
                    }
                }

            }

            completion(taken)
            print("is taken: " + String(taken))
            
        })
        
    }
    
    //Text Field Calls
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if textField == passwordTextOutlet {
            
            checkPasswordValid(textField: textField)
            
        }
        
        if textField == usernameTextOutlet {
            
            checkEmailValid(textField: textField)
        }
        
        if textField == retypePasswordText && passwordValid {
            
            if passwordTextOutlet.text != "" {
                
                if passwordTextOutlet.text == retypePasswordText.text {
                    
                    print("good")
                    
                    retypeValid = true
                    retypePasswordChecker.image = UIImage(named: "Checkmark")
                    
                } else {
                    
                    print("bad")
                    
                    retypeValid = false
                    retypePasswordChecker.image = UIImage(named: "RedX")
                    
                    let alertController = UIAlertController(title: "Hey", message: "Passwords do not match. Please try again.", preferredStyle:  UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                        
                        self.retypePasswordText.becomeFirstResponder()
                        
                        
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            }
            
        }

        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        
        if textField == retypePasswordText {
            
            if passwordValid {
                
                if passwordTextOutlet.text == retypePasswordText.text {
                    
                    retypeValid = true
                    retypePasswordChecker.image = UIImage(named: "Checkmark")
                    
                } else {
                    
                    retypeValid = false
                    retypePasswordChecker.image = UIImage(named: "RedX")
                    
                }
                
            }
            
        }
        
        if textField == passwordTextOutlet {
            
                if let count = textField.text?.characters.count {
                    
                    if count >= 5 {
                        passwordValid = true
                        passwordChecker.image = UIImage(named: "Checkmark")
                        //nextButtonOutlet.enabled = true
                    } else {
                        //nextButtonOutlet.enabled = false
                        passwordValid = false
                        passwordChecker.image = UIImage(named: "RedX")
                    }
                    
                    
                }
            
            
        }
        
        
        if textField == usernameTextOutlet {
            
            if let emailToCheck = textField.text {
                
                if isValidEmail(testStr: emailToCheck) {
                    
                    self.emailChecker.image = UIImage(named: "Checkmark")
                    
                    emailValid = true
                    
                    if passwordValid == true {
                        
                        //nextButtonOutlet.enabled = true
                        
                    }
                    
                    print("good email")
                    
                } else {
                    
                    emailChecker.image = UIImage(named: "RedX")
                    
                    emailValid = false
                    
                    print("Bad Email")
                    
                }
            }
            
        }
        
        
        
                    return true
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        return true
        
    }
    
    func textFieldDelegates() {
        
        usernameTextOutlet.delegate = self
        passwordTextOutlet.delegate = self
        retypePasswordText.delegate = self
        
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
        
        textFieldDelegates()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGestureRecognizer.delegate = self
        self.dismissKeyboard.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        usernameOutlet.layer.cornerRadius = 5
        passwordOutlet.layer.cornerRadius = 5
        retypePasswordOutlet.layer.cornerRadius = 5
        
        usernameTextOutlet.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTextOutlet.attributedPlaceholder = NSAttributedString(string: "Password (min 6 characters)", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
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
