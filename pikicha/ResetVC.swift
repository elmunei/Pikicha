//
//  ResetVC.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 7/19/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse


class ResetVC: UIViewController, UITextFieldDelegate {

    
    //Mark: - Outlets
    
    
    @IBOutlet weak var resetPwd: CustomizableTextfield!{
        didSet{
            resetPwd.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(ResetVC.hideKeyboard(_:)))
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
    

   
    // MARK: - Navigation

    
    @IBAction func resetBtn(_ sender: Any) {
        
        // if fields are empty
        if (resetPwd.text!.isEmpty) {
           
            // show alert message
            let alert = SCLAlertView()
            _ = alert.showError("Error", subTitle: "Email address cannot be empty. Please try again.")
            
            
            return
        }
        
        // hide keyboard
        self.view.endEditing(true)

        
        // request for reseting password
        PFUser.requestPasswordResetForEmail(inBackground: resetPwd.text!) { (success, error) -> Void in
            if success {
                
                let alert = SCLAlertView()
                _ = alert.showSuccess("Success", subTitle: "A reset password link has been sent to \(String(describing: self.resetPwd.text!))")
                
                
                
            } else {
                let alert = SCLAlertView()
                _ = alert.showError("Error", subTitle: error!.localizedDescription)
                
                
            }
        }


        
        
    }
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == resetPwd)
        {
            resetPwd.resignFirstResponder()
            return true
        }
            
       
        return false
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
