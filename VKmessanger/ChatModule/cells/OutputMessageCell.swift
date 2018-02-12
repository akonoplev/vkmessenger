//
//  OutputMessageCell.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 10.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class OutputMessageCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
    }
    
    func configure(model: Message) {
        messageLabel.text = model.text
    }

}
