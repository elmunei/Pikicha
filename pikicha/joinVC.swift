//
//  joinVC.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 7/18/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner

class joinVC: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate {
    
    
    //Mark - Outlets
    
    @IBOutlet weak var lblTxt: UILabel!
    
    
    @IBOutlet weak var fullNameTxt: UITextField!{
        didSet{
            fullNameTxt.delegate = self
        }
    }
    
    
    @IBOutlet weak var usernameTxt: UITextField!{
        didSet{
            usernameTxt.delegate = self
        }
    }
    
    @IBOutlet weak var emailTxt: UITextField!{
        didSet{
            emailTxt.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTxt: UITextField!{
        didSet{
            passwordTxt.delegate = self
        }
    }
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(joinVC.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(joinVC.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // declare hide kyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(joinVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }
    
    // hide keyboard if tapped
    func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // show keyboard func
    func showKeyboard(_ notification:Notification) {
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        
    }
    
    
    
    // hide keyboard func
    func hideKeyboard(_ notification:Notification) {
        
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    // regex restrictions for email textfield
    func validateEmail (_ email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    
    // clicked next button
    @IBAction func nextBtn_click(_ sender: AnyObject) {
        

        
        // if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullNameTxt.text!.isEmpty) {
            // Stop the spinner
            SwiftSpinner.hide()
            
            // show alert message
            let alert = SCLAlertView()
            _ = alert.showError("Error", subTitle: "One or more fields have not been filled. Please try again.")
            
            
            return
        }
        
        // if incorrect email according to regex
        if !validateEmail(emailTxt.text!) {
            // show alert message
            let alert = SCLAlertView()
            _ = alert.showError("Incorrect email format", subTitle: "please provide a valid email address")
            return
        }
        
        if (passwordTxt.text!.characters.count < 8) {
            // Stop the spinner
            SwiftSpinner.hide()
            
            // show alert message
            let alert = SCLAlertView()
            _ = alert.showError("Error", subTitle: "Password cannot be less than 8 characters")
            
            
            return
            
            
        }
        
        // Run a spinner to show a task in progress
        
        SwiftSpinner.show("Creating account...", animated: true)
        
        // send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text
        user["fullname"] = fullNameTxt.text?.lowercased()
        user["location"] = ""
        user["tags"] = ""
        user["description"] = ""
        user["gender"] = ""
        user["bio"] = ""
        user["web"] = ""
        
        
        
        // save data in server
        user.signUpInBackground { (success, error) -> Void in
            // Stop the spinner
            SwiftSpinner.hide()
            if success {
                print("registered")
                
                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                SwiftSpinner.hide()
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "photo") as! profilePictureVC
                self.present(nextViewController, animated:true, completion:nil)
                
                
                
                
            } else {
                SwiftSpinner.hide()
                // show alert message
                
                let alert = SCLAlertView()
                _ = alert.showError("Error", subTitle: error!.localizedDescription)
                
                return
                
            }
        }
        
        
        
    }
    
    
    //Textfield Delegates
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == fullNameTxt)
        {
            usernameTxt.becomeFirstResponder()
            return true
        }
            
        else if (textField == usernameTxt)
        {
            emailTxt.becomeFirstResponder()
            
            return true
        }
        else if (textField == emailTxt)
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
        animateView(up: true, moveValue: 70)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            70)
    }
    
    
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    
    
    
    
    // clicked cancel
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        
        
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
