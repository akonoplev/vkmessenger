//
//  ChatInterfaces.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit


protocol ChatViewInputInterface: class {
    func reloadData()
    func handlerError(error: String)
}

protocol  ChatViewOutputInterface: class {
    
}

protocol ChatFrcViewInterface: class {
    func beginUpdates()
    func endUpdates()
    func insert(to newIndexPath: IndexPath?)
    func update(indexPath: IndexPath?, object: Message)
    func move(from indexPath: IndexPath?, to newIndexPath: IndexPath?)
    func delete(indexPath: IndexPath?)
    
}

protocol ChatPresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(animate: Bool)
    func getData(offset: Int)
    func sendMessage(message: String)
    func numberOfEntities()-> Int
    func entityAt(index: IndexPath)-> Any?
}

protocol ChatInteractorInput: class {
    func getData(id: Int64, title: String, offset: Int, count: Int)
    func sendMessage(id: Int64, random_id: Int, message: String)
}

protocol ChatInteractorOutput: class {
    func success()-> Void
    func failure(error: String)-> Void
}

protocol ChatRouterInterface: class {
    func showMessage(message: Message)
    func setUpModule(fromViewController controller: UIViewController)
    func setUpModule(chat:Dialog)-> UIViewController
}
