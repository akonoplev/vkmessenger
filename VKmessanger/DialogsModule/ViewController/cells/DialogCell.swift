//
//  DialogCell.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 23.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var users: [User]?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "AvatarCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "avatarCell")
    }
    
    func configure(dialog: Dialog) {
        let usersInfo = dialog.dialogToUser?.allObjects as! [User]
        if dialog.type == "dialog" {
            titleLabel.text = usersInfo[0].name
            snippetLabel.text = dialog.snippet
            dateLabel.text = DateSerice.dateTransform(date: dialog.timestamp ?? Date(timeIntervalSince1970: 0))
            avatarImage.sd_setImage(with: URL(string: usersInfo[0].avatarURL ?? ""))
        } else {
            titleLabel.text = dialog.title
            snippetLabel.text = dialog.snippet
            dateLabel.text = DateSerice.dateTransform(date: dialog.timestamp ?? Date(timeIntervalSince1970: 0))
            if dialog.miltiChatURL != "" {
                avatarImage.sd_setImage(with: URL(string: dialog.miltiChatURL ?? ""))
            } 
        }
    }
}

extension DialogCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarCollectionViewCell
        guard let unwUsers = users else { return UICollectionViewCell() }
        cell.configure(user: unwUsers[indexPath.row])
        return cell
    }
}
