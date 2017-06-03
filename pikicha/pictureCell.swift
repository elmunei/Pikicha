//
//  pictureCell.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/05/30.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit

class pictureCell: UICollectionViewCell {
    
    // holds post picture
    @IBOutlet weak var picImg: UIImageView!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        picImg.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 3)
    }

    
}
