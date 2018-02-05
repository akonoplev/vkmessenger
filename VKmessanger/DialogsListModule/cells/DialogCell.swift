//
//  DialogCell.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 23.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var onlineMark: UIImageView!
    var chat: Dialog?
    var dataSource = [User]()
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "AvatarCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "avatarCell")
        collectionView.layer.cornerRadius = 25
    }
    
    func configure(dialog: Dialog) {
        
        chat = dialog

        if dialog.miltiChatURL == "empty" {
            dataSource = (dialog.dialogToUser?.allObjects)! as! [User]
        }
        
        let usersInfo = dialog.dialogToUser?.allObjects as! [User]
        
        if dialog.title != "" {
            titleLabel.text = dialog.title
        } else {
            titleLabel.text = usersInfo[0].name
        }
        
            snippetLabel.text = dialog.snippet
            dateLabel.text = DateSerice.dateTransform(date: dialog.timestamp ?? Date(timeIntervalSince1970: 0))

            if dialog.out {
                senderImage.sd_setImage(with: URL(string: ProfileService.sharedInstance.getAvatarUrl() ))
            } else {
                senderImage.image = nil
            }
            
            if dialog.isRead {
                snippetLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                snippetLabel.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            }
            
            if usersInfo[0].online {
                onlineMark.image = UIImage(named: "phone")
            } else {
                onlineMark.image = nil
            }
            
            collectionView.reloadData()
    }
}

extension DialogCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarCollectionViewCell
        if chat?.miltiChatURL == "empty" {
            cell.configure(url: dataSource[indexPath.item].avatarURL ?? "")
        } else {
            cell.configure(url: (chat?.miltiChatURL)!)
        }
        return cell
    }
}

extension DialogCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if dataSource.count == 1 {
            return collectionView.frame.size
        }
        else if dataSource.count == 2
        {
            return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
        }
        else
        {
            return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height/2)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}
