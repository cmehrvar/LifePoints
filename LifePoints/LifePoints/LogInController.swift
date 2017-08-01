//
//  ViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import NYAlertViewController
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LogInController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var LogInView: UIView!
    @IBOutlet weak var DismissKeyboard: UIView!
    @IBOutlet weak var UsernameView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var signInXConstrain: NSLayoutConstraint!
    
    weak var firstSignUp: firstSignUpViewController?
    
    @IBAction func facebookLogIn(_ sender: Any) {
        
        let alertController = NYAlertViewController()
        
        alertController.backgroundTapDismissalGestureEnabled = true
        
        alertController.title = nil
        alertController.message = "Do you agree to the terms of service LifePoints has provided?"
        
        alertController.messageColor = UIColor.darkGray
        
        alertController.buttonColor = UIColor.red
        alertController.buttonTitleColor = UIColor.white
        
        alertController.cancelButtonTitleColor = UIColor.white
        alertController.cancelButtonColor = UIColor.lightGray
        
        alertController.addAction(NYAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        alertController.addAction(NYAlertAction(title: "Agree", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: {
                
                let login: FBSDKLoginManager = FBSDKLoginManager()
                login.logIn(withReadPermissions: ["email", "user_birthday", "user_relationship_details", "user_work_history", "user_location", "user_friends"], from: self) { (result, error) in
                    
                    if error == nil {
                        
                        print("logged in")
                        if FBSDKAccessToken.current() != nil {
                            
                            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                            
                            Auth.auth().signIn(with: credential, completion: { (user, error) -> Void in
                                
                                if error == nil {
                                    
                                    if let uid = user?.uid {
                                        
                                        let businessReq = FBSDKGraphRequest(graphPath: "me/ids_for_business", parameters: nil, httpMethod: "GET")
                                        
                                        businessReq?.start(completionHandler: { (connection, result, error) in
                                            
                                            if error == nil {
                                                
                                                print(result)
                                                
                                                if let dictResult = result as? [AnyHashable : Any], let data = dictResult["data"] as? [[AnyHashable : Any]] {
                                                    
                                                    for value in data {
                                                        
                                                        if let id = value["id"] as? String {
                                                            
                                                            Database.database().reference().child("facebookUIDs").child(id).setValue(uid)
                                                            Database.database().reference().child("users").child(uid).child("facebookId").setValue(id)
                                                            
                                                        }
                                                    }
                                                }
                                                
                                            } else {
                                                
                                                print(error)
                                                
                                            }
                                            
                                        })
                                        
                                        
                                        self.checkIfTaken("users", credential: uid, completion: { (taken) in
                                            
                                            if !taken {
                                                
                                                if let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, first_name, last_name, gender, birthday, age_range, interested_in, work, location, picture"], tokenString: result?.token.tokenString, version: nil, httpMethod: "GET") {
                                                    
                                                    req.start(completionHandler: { (connection, result, error) in
                                                        
                                                        if error == nil {
                                                            
                                                            if let graphResult = result as? [AnyHashable : Any] {
                                                                
                                                                var userData = [AnyHashable: Any]()
                                                                
                                                                print(graphResult)
                                                                
                                                                if let birthday = graphResult["birthday"] as? String {
                                                                    
                                                                    let dateFormatter = DateFormatter()
                                                                    dateFormatter.dateFormat = "MM-dd-yyyy"
                                                                    
                                                                    if let date = dateFormatter.date(from: birthday) {
                                                                        
                                                                        let timeInterval = date.timeIntervalSince1970
                                                                        userData["age"] = timeInterval
                                                                        
                                                                    } else if let ageRange = graphResult["age_range"] as? [String : Int], let minAge = ageRange["min"] {
                                                                        
                                                                        userData["minAge"] = minAge
                                                                        
                                                                    }
                                                                }
                                                                
                                                                print(graphResult)
                                                                
                                                                if let email = graphResult["email"] as? String {
                                                                    userData["email"] = email
                                                                }
                                                                
                                                                if let gender = graphResult["gender"] as? String {
                                                                    userData["gender"] = gender
                                                                }
                                                                
                                                                if let id = graphResult["id"] as? String {
                                                                    userData["profilePicture"] = "https://graph.facebook.com/" + id + "/picture?type=large"
                                                                }
                                                                
                                                                
                                                                if let firstName = graphResult["first_name"] as? String {
                                                                    
                                                                    userData["firstName"] = firstName
                                                                    
                                                                }
                                                                
                                                                if let lastName = graphResult["last_name"] as? String {
                                                                    
                                                                    userData["lastName"] = lastName
                                                                    
                                                                }
                                                                
                                                                if let occupations = graphResult["work"] as? [[AnyHashable: Any]], let latest = occupations.first, let position = latest["position"] as? [AnyHashable: Any], let name = position["name"] as? String, let employer = latest["employer"] as? [AnyHashable: Any], let employerName = employer["name"] as? String{
                                                                    
                                                                    userData["employer"] = employerName
                                                                    userData["occupation"] = name
                                                                    
                                                                }
                                                                
                                                                if let currentCity = graphResult["location"] as? [String : AnyObject], let name = currentCity["name"] as? String {
                                                                    
                                                                    let components = name.components(separatedBy: ", ")
                                                                    
                                                                    if components.count >= 1 {
                                                                        
                                                                        let city = components[0]
                                                                        userData["city"] = city.replacingOccurrences(of: ".", with: "")
                                                                        
                                                                    }
                                                                    
                                                                    if components.count == 2 {
                                                                        userData["state"] = components[1]
                                                                    }
                                                                }
                                                                
                                                                
                                                                userData["uid"] = uid
                                                                userData["online"] = true
                                                                userData["lastActive"] = Date().timeIntervalSince1970
                                                                userData["points"] = 0
                                                                
                                                                let ref = Database.database().reference()
                                                                ref.keepSynced(true)
                                                                
                                                                ref.child("users").child(uid).setValue(userData)
                                                                
                                                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainRootController") as?  MainRootController {
                                                                    
                                                                    self.present(vc, animated: true, completion: {
                                                                        
                                                                                                                                            })
                                                                }

                                                                
                                                                
                                                            }
                                                        }
                                                    })
                                                    
                                                }
                                                
                                            } else {
                                                
                                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainRootController") as? MainRootController {
                                                    
                                                    self.present(vc, animated: true, completion: {
                                                        
                                                        
                                                    })
             
                                                }
                                                
                                            }
                                        })
                                    }
                                    
                                } else {
                                    print(error)
                                }
                            })
                        } else {
                            
                            print("no token")
                            
                        }
                    }
                }
            })
        }))
        
        
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    
    @IBAction func usernameLogIn(_ sender: Any) {
        
        if let email = UsernameTextField.text, let password = PasswordTextField.text {
            
            let alertController = NYAlertViewController()
            
            alertController.backgroundTapDismissalGestureEnabled = true
            
            alertController.title = nil
            
            
            alertController.messageColor = UIColor.darkGray
            
            alertController.buttonColor = UIColor.red
            alertController.buttonTitleColor = UIColor.white
            
            alertController.cancelButtonTitleColor = UIColor.white
            alertController.cancelButtonColor = UIColor.lightGray
            
            alertController.addAction(NYAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            alertController.addAction(NYAlertAction(title: "Ok", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: {
                    
                    
                    
                })
            }))
            
            //Add condition to find valid e-mail
            
            if email == ""  {
                
                print("no email")
                alertController.message = "Please enter a valid e-mail."
                self.present(alertController, animated: true, completion: nil)
                
            } else if password == "" {
                
                print("no password")
                alertController.message = "Please enter a valid password."
                self.present(alertController, animated: true, completion: nil)
                
            } else if password.characters.count < 6 {
                
                print("password less than 6 characters")
                alertController.message = "Please enter a password with minimum 6 characters."
                self.present(alertController, animated: true, completion: nil)
                
                
            } else {
                
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in

                    if error == nil {
                        
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainRootController") as? MainRootController {
                            
                            self.present(vc, animated: true, completion: {
                                
                                
                            })
                            
                        }

    
                    } else {

                        print(error?.localizedDescription)
                        
                        if error?.localizedDescription == "The password is invalid or the user does not have a password." {
                            
                            alertController.message = "The password entered is incorrect. Please try again."
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                        if error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                            
                            alertController.message = "\(email) could not be found as a registered e-mail. Please try again or reset password."
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                        
                        
                        if error?.localizedDescription == "The email address is badly formatted." {
                            
                            alertController.message = "Please enter a valid e-mail"
                            self.present(alertController, animated: true, completion: nil)
                        }
 
                        
                    }
                    
                    
                })
                
            }
            
            
            
            
        } else {
            
            print("no username, no password")
            
        }
        
        
        
    }
    
    
    
    func checkIfTaken(_ key: String, credential: String, completion: @escaping (_ taken: Bool) -> ()) {
        
        let ref = Database.database().reference()
        ref.keepSynced(true)
        
        ref.child(key).child(credential).observeSingleEvent(of: .value, with:  { (snapshot) in
            
            if snapshot.exists() {
                
                if let value = snapshot.value as? [AnyHashable: Any] {
                    
                    if value["uid"] == nil {
                        
                        completion(false)
                        
                    } else {
                        
                        completion(true)
                        
                    }
                    
                } else {
                    
                    completion(false)
                    
                }
                
            } else {
                
                completion(false)
                
            }
            
            completion(snapshot.exists())
            
        })
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissTap.delegate = self
        DismissKeyboard.addGestureRecognizer(dismissTap)
        
        self.UsernameView.layer.cornerRadius = 5
        self.PasswordView.layer.cornerRadius = 5
        
        self.LogInView.layer.cornerRadius = 5
        
        
        UsernameTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password (min 6 characters)", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])

        
        
    }
    
    
    func toggleSignIn(action: String, completion: @escaping (Bool) -> ()) {
        
        var constraint: CGFloat = 0
        
        if action == "close" {
            
            constraint = self.view.bounds.width

        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.signInXConstrain.constant = constraint
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            completion(bool)
            
        }
        
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
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        toggleSignIn(action: "open") { (bool) in
            
            print("sign in opened")
            
        }
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "SignUpOne" {
            
            let signUp = segue.destination as? firstSignUpViewController
            firstSignUp = signUp
            firstSignUp?.logIn = self
            
        }
     }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}

