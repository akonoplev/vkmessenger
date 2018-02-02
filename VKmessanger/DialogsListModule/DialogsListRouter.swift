//
//  DialogsListRouter.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 31.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import UIKit

class DialogsListRouter: DialogsListRouterInterface {
    private let storyboard = UIStoryboard(name: "DialogsList", bundle: nil)
    
    func showChat(id: Int) {
        
    }
    
    func setUpModule(fromViewController controller: UIViewController) {
        
    }
    
    func setUpModule() -> UIViewController {
        let initialController = storyboard.instantiateViewController(withIdentifier: "dialogsList") as! DialogsListViewController
        let presenter = DialogsListPresenter()
        let interactor = DialogsListInteractor()
        
        initialController.presenter = presenter
        presenter.view = initialController
        
        presenter.interactor = interactor
        interactor.output = presenter
        
        return initialController
    }
}
