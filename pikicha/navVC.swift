//
//  navVC.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/06/01.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit

class navVC: UINavigationController {

    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of title at the top in nav controller
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // color of buttons in nav controller
        self.navigationBar.tintColor = .white
        
        // color of background of nav controller
        self.navigationBar.barTintColor = UIColor(red: 8/255, green: 165/255, blue: 137/255, alpha: 1.0)
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }
    
    
    // white status bar function
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }


}
