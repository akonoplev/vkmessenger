//
//  AvatarCollectionViewCell.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 29.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import SDWebImage

class AvatarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    
    }
    
    func configure(url: String) {
        avatarImage.sd_setImage(with: NSURL(string: url ) as URL? )
    }

}
