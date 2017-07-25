//
//  profilePictureVC.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 7/18/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner
import FaceAware


class profilePictureVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    
    @IBOutlet weak var pp: UIImageView!
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var joinBtn: CustomizableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        lb4.isHidden = true
        
        // round avatar
        pp.layer.cornerRadius = pp.frame.size.width / 2
        pp.clipsToBounds = true
        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(profilePictureVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        pp.isUserInteractionEnabled = true
        pp.addGestureRecognizer(avaTap)
    }

    
  
    // call picker to select image
    func loadImg(_ recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pp.image = info[UIImagePickerControllerEditedImage] as? UIImage
        pp.focusOnFaces = true
       // pp.debugFaceAware = true
        lbl1.isHidden = true
        lb2.isHidden = true
        lbl3.isHidden = true
        lb4.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    //Spinner
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
    
    // MARK: - Actions

    @IBAction func joinBtn(_ sender: Any) {
        // Run a spinner to show a task in progress
        
        SwiftSpinner.show("Adding your cool picture 🤗", animated: true)
        
        // if no pp
        if  pp.image! == UIImage(named: "pp")! {
            // Stop the spinner
            SwiftSpinner.hide()
            
            // show alert message
            
            let alert = SCLAlertView()
            _ = alert.showError("Error", subTitle: "Please add a profile picture")
            
            return
        }
        
        // save image in information
        let user = PFUser.current()!
        let avaData = UIImageJPEGRepresentation(pp.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        user.saveInBackground (block: { (success, error) -> Void in
            if success{
                SwiftSpinner.hide()
                // hide keyboard
                self.view.endEditing(true)
                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                ProgressHUD.dismiss()
                // call login func from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
                
                
                
            } else {
                SwiftSpinner.hide()
                // show alert message
                
                let alert = SCLAlertView()
                _ = alert.showError("Error", subTitle: error!.localizedDescription)
                
                
                
            }

        })
    }
 
    @IBAction func skipBtn(_ sender: Any) {
        
        
        
        // call login function from AppDelegate.swift class
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.login()

    }

}
