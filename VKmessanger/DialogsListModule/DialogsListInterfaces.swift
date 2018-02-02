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

protocol DialogsListPresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func numberOfEntities() -> Int
    func entityAt(index: IndexPath)-> Any?
}

protocol DialogsListInteractorInput: class {
    func getData()
}

protocol DialogsListInteractorOutput: class {
    func success()
    func failure(error: String)
}

protocol DialogsListRouterInterface: class {
    func showChat(id: Int)
    func setUpModule(fromViewController controller: UIViewController)
    func setUpModule()-> UIViewController
}
