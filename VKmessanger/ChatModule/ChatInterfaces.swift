//
//  ChatInterfaces.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit


protocol ChatViewInterface: class {
    func reloadData()
    func handlerError(error: String)
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
    func getData(offset: Int)
    func numberOfEntities()-> Int
    func entityAt(index: IndexPath)-> Any?
}

protocol ChatInteractorInput: class {
    func getData(offset: Int)
}

protocol ChatInteractorOutput: class {
    func success()
    func failure()
}

protocol ChatRouterInterface: class {
    func setUpModule(fromViewController controller: UIViewController)
    func setUpModule()-> UIViewController
}
