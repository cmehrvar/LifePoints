//
//  ProfileViewController.swift
//  LifePoints
//
//  Created by Cina Mehrvar on 2017-05-15.
//  Copyright © 2017 Cina Mehrvar. All rights reserved.
//A29DCB

import UIKit
import Firebase
import SDWebImage
import NYAlertViewController
import AWSCore
import AWSS3

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBAction func editProfile(_ sender: Any) {
        
        self.presentImagePicker()
        
        
    }

    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.profileImage.image = image
        self.backgroundImage.image = image
        
        self.dismiss(animated: true) {
            
            self.imageUploadRequest(image) { (url, uploadRequest) in
                
                let transferManager = AWSS3TransferManager.default()
                
                transferManager.upload(uploadRequest).continueWith(block: { (task) -> Any? in
                    
                    if task.error == nil {
                        
                        print("successful image upload")
                        let ref = Database.database().reference()
                        
                        if let uid = Auth.auth().currentUser?.uid {
                            ref.child("users").child(uid).updateChildValues(["profilePicture": url])
                        }
                        
                    } else {
                        print("error uploading: \(task.error)")
                        
                        let alertController = UIAlertController(title: "Sorry", message: "Error uploading profile picture, please try again later", preferredStyle:  UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                    return nil
                })
            }
        }
    }
    
    func imageUploadRequest(_ image: UIImage, completion: @escaping (_ url: String, _ uploadRequest: AWSS3TransferManagerUploadRequest) -> ()) {
        
        let fileName = ProcessInfo.processInfo.globallyUniqueString + ".jpeg"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("upload").appendingPathComponent(fileName)
        let filePath = fileURL.path
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        //SEGMENTATION BUG, IF FAULT 11 - COMMENT OUT AND REWRITE
        DispatchQueue.main.async {
            try? imageData?.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
            
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.body = fileURL
            uploadRequest?.key = fileName
            uploadRequest?.bucket = "cityscapebucket"
            
            var imageUrl = ""
            
            if let key = uploadRequest?.key {
                imageUrl = "https://s3.amazonaws.com/cityscapebucket/" + key
                
            }
            
            completion(imageUrl, uploadRequest!)
        }
    }
    
    
    
    func presentImagePicker(){

        let cameraProfile = UIImagePickerController()
        
        cameraProfile.delegate = self
        cameraProfile.allowsEditing = false
        
        let alertController = UIAlertController(title: "Edit Profile Picture", message: "Take a pic or choose from gallery?", preferredStyle:  UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            
            cameraProfile.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(cameraProfile, animated: true, completion: nil)
            
        }))
        
        
        alertController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                cameraProfile.sourceType = UIImagePickerControllerSourceType.camera
            }
            
            self.present(cameraProfile, animated: true, completion: nil)
            
        }))
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }

    
    
    func loadPage(){
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("users").child(uid)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let data = snapshot.value as? [AnyHashable : Any] {
                    
                    if let firstName = data["firstName"] as? String, let lastName = data["lastName"] as? String {
     
                        self.nameOutlet.text = firstName + " " + lastName
                        
                    }
                    
                    if let profilePic = data["profilePicture"] as? String, let url = URL(string: profilePic) {
                        
                        self.profileImage.sd_setImage(with: url)
                        self.backgroundImage.sd_setImage(with: url)
                        
                    }
                }
            })
        }
    }
    
    func addUploadStuff(){
        
        let error = NSErrorPointer.init(nilLiteral: ())
        
        do{
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("upload"), withIntermediateDirectories: true, attributes: nil)
        } catch let error1 as NSError {
            error?.pointee = error1
            print("Creating upload directory failed. Error: \(error)")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUploadStuff()
        loadPage()
        
        self.profileImage.layer.cornerRadius = 45
        self.profileImage.layer.borderColor = hexStringToUIColor(hex: "A29DCB").cgColor
        self.profileImage.layer.borderWidth = 2

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
