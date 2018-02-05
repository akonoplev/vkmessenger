//
//  CustomViews.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

//MARK: - avatars in friends list,dialogs list and other
class CustomUserAvatarImage: UIImageView {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: superview)
        setStyle()
    }
    
    private func setStyle() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 25
        layer.masksToBounds = true
        
    }
}

class CustomUserSenderImage: UIImageView {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: superview)
        setStyle()
    }
    
    private func setStyle() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
    }
}
