//
//  secondSignUpViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-28.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//

import UIKit
import DownPicker

class secondSignUpViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var sexView: UIView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var ageDownPicker: UIDownPicker!
    
    
    @IBOutlet weak var thirdSignUpConst: NSLayoutConstraint!
    

    weak var thirdSignUp: ThirdSignUpViewController?
    weak var firstSignUp: firstSignUpViewController?
    
    @IBOutlet weak var firstNameViewOutlet: UIView!
    @IBOutlet weak var lastNameViewOutlet: UIView!
    @IBOutlet weak var firstNameTextOutlet: UITextField!
    @IBOutlet weak var lastNameTextOutlet: UITextField!
    @IBOutlet weak var dismissKeyboardView: UIView!
    
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    
    var sex: String = "male"
    
    
    func addDownPickerData(){
        
        var data = [String]()
        
        for i in 12...99 {
            
            data.append(String(i))
            
        }
        
        ageDownPicker.downPicker = DownPicker(textField: ageDownPicker, withData: data)
        
        ageDownPicker.downPicker.setAttributedPlaceholder(NSAttributedString(string: "Select", attributes: [NSForegroundColorAttributeName: UIColor.lightGray]))
        
        
        
    }
    
    
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
    
    func selectMale(){
        
        sex = "male"
        
        maleView.backgroundColor = hexStringToUIColor(hex: "4C4BD4")
        femaleView.backgroundColor = UIColor.clear
        
    }
    
    func selectFemale(){
        
        sex = "female"
        
        maleView.backgroundColor = UIColor.clear
        femaleView.backgroundColor = hexStringToUIColor(hex: "4C4BD4")
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if firstNameTextOutlet.text != "" && lastNameTextOutlet.text != "" {
            
            nextButtonOutlet.isEnabled = true
            
        } else {

            nextButtonOutlet.isEnabled = false
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if firstNameTextOutlet.text != "" && lastNameTextOutlet.text != "" {
            
            nextButtonOutlet.isEnabled = true
            
        } else {
            
            nextButtonOutlet.isEnabled = false
            
        }

        
        return true
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        addDownPickerData()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let closeKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        closeKeyboardGestureRecognizer.delegate = self
        self.dismissKeyboardView.addGestureRecognizer(closeKeyboardGestureRecognizer)
        
        let maleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectMale))
        maleGestureRecognizer.delegate = self
        maleView.addGestureRecognizer(maleGestureRecognizer)
        
        let femaleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectFemale))
        femaleGestureRecognizer.delegate = self
        femaleView.addGestureRecognizer(femaleGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

        ageView.layer.cornerRadius = 5
        sexView.layer.cornerRadius = 5
        
        maleView.layer.cornerRadius = 5
        femaleView.layer.cornerRadius = 5
        
        firstNameViewOutlet.layer.cornerRadius = 5
        lastNameViewOutlet.layer.cornerRadius = 5
        
        firstNameTextOutlet.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        lastNameTextOutlet.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        firstNameTextOutlet.delegate = self
        lastNameTextOutlet.delegate = self
        
        nextButtonOutlet.isEnabled = false
        nextButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        nextButtonOutlet.setTitleColor(UIColor.lightGray, for: .disabled)
        
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
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
