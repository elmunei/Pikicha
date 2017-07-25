//
//  loginVC.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 7/18/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner

class loginVC: UIViewController, UITextFieldDelegate {

    // textfield
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var usernameTxt: CustomizableTextfield! {
        didSet{
            usernameTxt.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTxt: CustomizableTextfield! {
        didSet{
            passwordTxt.delegate = self
        }
    }
    
    // buttons
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
                
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(loginVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
    }

    // hide keyboard func
    func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // white status bar function
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    private func hideForgotDetailButton(isHidden: Bool){
        self.forgotBtn.isHidden = isHidden
    }
    
    // clicked sign in button
    @IBAction func loginInBtn_click(_ sender: AnyObject) {
        SwiftSpinner.show("Please wait...", animated: true)
        print("sign in pressed")
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            SwiftSpinner.hide()
            let alert = SCLAlertView()
            _ = alert.showError("Error", subTitle: "One or more fields have not been filled. Please try again.")
            
            
            return
        }

            
            // login functions
            PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user, error) -> Void in
                if error == nil {
                    SwiftSpinner.hide()
                    // remember user or save in App Memory did the user login or not
                    UserDefaults.standard.set(user!.username, forKey: "username")
                    UserDefaults.standard.synchronize()
                    
                    // call login function from AppDelegate.swift class
                    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.login()
                    
                } else {
                    
                    // show alert message
                    SwiftSpinner.hide()
                    let alert = SCLAlertView()
                    _ = alert.showWarning("Error", subTitle: error!.localizedDescription)
                    
                    
                }
            }
            
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == usernameTxt)
        {
            passwordTxt.becomeFirstResponder()
            return true
        }
            
        else if (textField == passwordTxt)
        {
            passwordTxt.resignFirstResponder()
            
            return true
        }
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 80)
        hideForgotDetailButton(isHidden: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            80)
        hideForgotDetailButton(isHidden: false)
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
