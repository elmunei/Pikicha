//
//  editProfile.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/05/31.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import Parse

class editProfile: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    // UI objects
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var telTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    // pickerView & pickerData
    var genderPicker : UIPickerView!
    let genders = ["male","female", "Other"]
    
    // value to hold keyboard frame size
    var keyboard = CGRect()
    
    let CharacterLimit = 140
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bioTxt.delegate = self
        
        // create picker
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        genderTxt.inputView = genderPicker
        
        // check notifications of keyboard - shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(editProfile.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editProfile.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(editProfile.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // tap to choose image
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(editProfile.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        // call alignment function
        alignment()
        
        // call information function
        information()
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (bioTxt.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 140
    }
    
  
    
    // func to hide keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // func when keyboard is shown
    func keyboardWillShow(_ notification: Notification) {
        
        // define keyboard frame size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up with animation
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        })
    }
    
    
    // func when keyboard is hidden
    func keyboardWillHide(_ notification: Notification) {
        
        // move down with animation
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.contentSize.height = 0
        })
    }
    
    
    // func to call UIImagePickerController
    func loadImg (_ recognizer : UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    // method to finalize our actions with UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // alignment function
    func alignment() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        avaImg.frame = CGRect(x: width - 68 - 10, y: 15, width: 68, height: 68)
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        fullnameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y, width: width - avaImg.frame.size.width - 30, height: 30)
        usernameTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: width - avaImg.frame.size.width - 30, height: 30)
        webTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
        bioTxt.frame = CGRect(x: 10, y: webTxt.frame.origin.y + 40, width: width - 20, height: 60)
        bioTxt.layer.borderWidth = 1
        bioTxt.layer.borderColor = UIColor(red: 230 / 255.5, green: 230 / 255.5, blue: 230 / 255.5, alpha: 1).cgColor
        bioTxt.layer.cornerRadius = bioTxt.frame.size.width / 50
        bioTxt.clipsToBounds = true
        
        emailTxt.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 100, width: width - 20, height: 30)
        telTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: width - 20, height: 30)
        genderTxt.frame = CGRect(x: 10, y: telTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
        titleLbl.frame = CGRect(x: 15, y: emailTxt.frame.origin.y - 30, width: width - 20, height: 30)
    }
    
    
    // user information function
    func information() {
        
        // receive profile picture
        let ava = PFUser.current()?.object(forKey: "ava") as! PFFile
        ava.getDataInBackground { (data, error) -> Void in
            self.avaImg.image = UIImage(data: data!)
        }
        
        // receive text information
        usernameTxt.text = PFUser.current()?.username
        fullnameTxt.text = PFUser.current()?.object(forKey: "fullname") as? String
        bioTxt.text = PFUser.current()?.object(forKey: "bio") as? String
        webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        
        emailTxt.text = PFUser.current()?.email
        telTxt.text = PFUser.current()?.object(forKey: "phone") as? String
        genderTxt.text = PFUser.current()?.object(forKey: "gender") as? String
    }
    
    
    // regex restrictions for email textfield
    func validateEmail (_ email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    // regex restrictions for web textfield
    func validateWeb (_ web : String) -> Bool {
        let regex = "www.+[A-Z0-9a-z._%+-]+.[A-Za-z]{3}"
        let range = web.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    
    // alert message function
    func alert (_ error: String, message : String) {
        ProgressHUD.dismiss()
        let alert = SCLAlertView()
        _ = alert.showWarning(error, subTitle: message)
       
    }
    
    
    // clicked save button
    @IBAction func save_clicked(_ sender: AnyObject) {
        
        // if incorrect email according to regex
        if !validateEmail(emailTxt.text!) {
            alert("Incorrect email", message: "please provide a valid email address")
            return
        }
        
        // if incorrect weblink according to regex
        if !validateWeb(webTxt.text!) {
            alert("Incorrect url", message: "please provide a valid website or blog address")
            return
        }
        ProgressHUD.show("Saving data...", interaction: false)
        // save filled in information
        let user = PFUser.current()!
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["web"] = webTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        
        // if "tel" is empty, send empty data, else entered data
        if telTxt.text!.isEmpty {
            user["phone"] = ""
        } else {
            user["phone"] = telTxt.text
        }
        
        // if "gender" is empty, send empty data, else entered data
        if genderTxt.text!.isEmpty {
            user["gender"] = ""
        } else {
            user["gender"] = genderTxt.text
        }
        
        // send profile picture
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        // send filled information to server
        user.saveInBackground (block: { (success, error) -> Void in
            if success{
                ProgressHUD.dismiss()
                // hide keyboard
                self.view.endEditing(true)
                
                // dismiss editProfile
                self.dismiss(animated: true, completion: nil)
                
                // send notification to homeVC to be reloaded
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: nil)
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    
    // clicked cancel button
    @IBAction func cancel_clicked(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // PICKER VIEW METHODS
    // picker comp numb
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // picker text numb
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    // picker text config
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    // picker did selected some value from it
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
}
}
