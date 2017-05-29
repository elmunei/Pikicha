//
//  ResetPasswordViewController.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/05/27.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import Parse


class ResetPasswordViewController: UIViewController {
    
    // textfield
    @IBOutlet weak var emailTxt: UITextField!
    
    // buttons
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // alignment
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height: 30)
        
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        resetBtn.layer.cornerRadius = resetBtn.frame.size.width / 20
        
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: resetBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "cosmo.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    
    
    // clicked reset button
    @IBAction func resetBtn_click(_ sender: AnyObject) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        // email textfield is empty
        if emailTxt.text!.isEmpty {
            
            // show alert message
            let alert = UIAlertController(title: "", message: "Email field is empty", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        // request for reseting password
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success, error) -> Void in
            if success {
                
                // show alert message
                let alert = UIAlertController(title: "", message: "A reset password link has been sent to \(String(describing: self.emailTxt.text!))", preferredStyle: UIAlertControllerStyle.alert)
                
                // if pressed OK call self.dismiss.. function
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
    }
    
    
    // clicked cancel button
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
