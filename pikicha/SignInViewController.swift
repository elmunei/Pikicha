//
//  SignInViewController.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/05/27.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import Parse



class SignInViewController: UIViewController, UITextFieldDelegate {
    
    
    // textfield
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var usernameTxt: CustomizableTextfield! {
        didSet{
            usernameTxt.delegate = self
        }
    }

    @IBOutlet weak var passwordTxt: UITextField! {
        didSet{
            passwordTxt.delegate = self
        }
    }

    
    // buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        // Baloo font of label
       
        label.font = UIFont(name: "BalooChettan", size: 80)
        label.textColor = UIColor.white
        label.shadowColor = UIColor.black

        
        // alignment
        label.frame = CGRect(x: 10, y: 40, width: self.view.frame.size.width - 20, height: 180)
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 180, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
        
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.size.width / 4, height: 30)
        signInBtn.layer.cornerRadius = signInBtn.frame.size.width / 20
        
        signUpBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: signInBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "cosmo.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)


        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    // hide keyboard func
    func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
    // clicked sign in button
    @IBAction func signInBtn_click(_ sender: AnyObject) {
    
        print("sign in pressed")
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
             ProgressHUD.dismiss()
            // show alert message
//            let alert = SCLAlertView()
//            _ = alert.showWarning("Error", subTitle: "One or more fields has not been filled. Please try again.")
        }
        
        // login functions
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user, error) -> Void in
            if error == nil {
                
                // remember user or save in App Memory did the user login or not
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                ProgressHUD.show("Please wait...", interaction: false)
                
                // call login function from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                
                // show alert message
                 ProgressHUD.dismiss()
                let alert = SCLAlertView()
                _ = alert.showWarning("Error", subTitle: error!.localizedDescription)
                
            
            }
        }

    
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        return true
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 80)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            80)
       
    }
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
        
    }

   

 
}
