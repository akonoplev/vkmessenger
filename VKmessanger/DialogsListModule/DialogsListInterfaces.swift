//
//  DialogsListInterfaces.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 31.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import UIKit

protocol DialogsListViewInterface: class {
    func reloadData()
    func handleInternetError(error: String)
}

protocol DialogsListFrcViewChange: class {
    func beginUpdates()
    func endUpdates()
    func insert(to newIndexPath: IndexPath?)
    func update(indexPath: IndexPath?, object: Dialog)
    func move(from indexPath: IndexPath?, to newIndexPath: IndexPath?)
    func delete(indexPath: IndexPath?)
}

protocol DialogsListPresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func getData(offset: Int)
    func numberOfEntities() -> Int
    func entityAt(index: IndexPath)-> Any?
}

protocol DialogsListInteractorInput: class {
    func getData(offset: Int)
}

protocol DialogsListInteractorOutput: class {
    func success()
    func failure(error: String)
}

protocol DialogsListRouterInterface: class {
    func showChat(id: Int64)
    func setUpModule(fromViewController controller: UIViewController)
    func setUpModule()-> UIViewController
}
