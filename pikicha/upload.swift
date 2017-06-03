//
//  upload.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/06/01.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import Parse

class upload: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI objects
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var publishBtn: CustomizableButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
  
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        // disable publish btn
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = .lightGray
        
        // hide remove button
        removeBtn.isHidden = true
        
        // standart UI 
        picImg.image = UIImage(named: "placeholder.jpg")
        
        
        
        // hide kyeboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(upload.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(upload.selectImg))
        picTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)
    }
    
    
    // preload func
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        // call alignment function
 
        alignment()
    }
 
    
    // hide kyeboard function
    func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    
    // func to cal pickerViewController
    func selectImg() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    // hold selected image in picImg object and dissmiss PickerController()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        // enable publish btn
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor(red: 8/255, green: 165/255, blue: 137/255, alpha: 1.0)
        
        // unhide remove button
        removeBtn.isHidden = false
        
        // implement second tap for zooming image
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(upload.zoomImg))
        zoomTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
    }
    
    
    // zooming in / out function
    func zoomImg() {
        
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // frame of unzoomed (small) image
        let unzoomed = CGRect(x: 15, y: 15, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
        
        // if picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                self.picImg.frame = zoomed
                
                // hide objects from background
                self.view.backgroundColor = .black
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
                self.removeBtn.alpha = 0
                
            })
            
            // to unzoom
        } else {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                self.picImg.frame = unzoomed
                
                // unhide objects from background
                self.view.backgroundColor = .white
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
                self.removeBtn.alpha = 1
            })
        }
        
    }
    
    
    // alignment
    func alignment() {
        
        let width = self.view.frame.size.width
        
        
        picImg.frame = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        titleTxt.frame = CGRect(x: picImg.frame.size.width + 25, y: picImg.frame.origin.y, width: width / 1.488, height: picImg.frame.size.height)
        publishBtn.frame = CGRect(x: 130, y: 180, width: 100, height: 50)
        removeBtn.frame = CGRect(x: picImg.frame.origin.x, y: picImg.frame.origin.y + picImg.frame.size.height, width: picImg.frame.size.width, height: 20)
    }
    
    
    // clicked publish button
    @IBAction func publishBtn_clicked(_ sender: AnyObject) {
        ProgressHUD.show("Uploading...", interaction: false)
        // dissmiss keyboard
        self.view.endEditing(true)
        
        // send data to server to "posts" class in Parse
        let object = PFObject(className: "posts")
        object["username"] = PFUser.current()!.username
        object["ava"] = PFUser.current()!.value(forKey: "ava") as! PFFile
        
        let uuid = UUID().uuidString
        object["uuid"] = "\(PFUser.current()!.username!) \(uuid)"
        
        if titleTxt.text.isEmpty {
            object["title"] = ""
        } else {
            object["title"] = titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        // send pic to server after converting to FILE and comprassion
        let imageData = UIImageJPEGRepresentation(picImg.image!, 0.5)
        let imageFile = PFFile(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        
        // send #hashtag to server
        let words:[String] = titleTxt.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        /*
        // define taged word
        for var word in words {
            
            // save #hasthag in server
            if word.hasPrefix("#") {
                
                // cut symbold
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                word = word.trimmingCharacters(in: CharacterSet.symbols)
                
                let hashtagObj = PFObject(className: "hashtags")
                hashtagObj["to"] = "\(PFUser.current()!.username!) \(uuid)"
                hashtagObj["by"] = PFUser.current()?.username
                hashtagObj["hashtag"] = word.lowercased()
                hashtagObj["comment"] = titleTxt.text
                hashtagObj.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("hashtag \(word) is created")
                    } else {
            ProgressHUD.dismiss()
                        print(error!.localizedDescription)
                    }
                })
            }
        }
        */
        
        // finally save information
        object.saveInBackground (block: { (success, error) -> Void in
            if error == nil {
                ProgressHUD.dismiss()
                // send notification wiht name "uploaded"
                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploaded"), object: nil)
                
                // switch to another ViewController at 0 index of tabbar
                self.tabBarController!.selectedIndex = 0
                
                // reset everything
                self.viewDidLoad()
                self.titleTxt.text = ""
            }
        })
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.viewDidLoad()
        self.titleTxt.text = ""
        self.tabBarController!.selectedIndex = 0
    }
    
    // clicked remove button
    @IBAction func removeBtn_clicked(_ sender: AnyObject) {
        self.viewDidLoad()
        self.titleTxt.text = ""
    }

}
