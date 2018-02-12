//
//  ChatRouter.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import UIKit


class ChatRouter: ChatRouterInterface {
    
    let storyboard = UIStoryboard(name: "Chat", bundle: nil)
    
    func showMessage(message: Message) {
        
    }
    
    
    func setUpModule(fromViewController controller: UIViewController) {
        
    }
    
    func setUpModule(chat : Dialog) -> UIViewController {
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "chatStoryboard") as! ChatViewController
        let presenter = ChatPresenter(chat: chat)
        let interactor = ChatInteractor()
        
        chatViewController.presenter = presenter
        
        presenter.view = chatViewController
        presenter.viewFrc = chatViewController
        presenter.interactor = interactor
        
        interactor.output = presenter
        return chatViewController
    }
    
    
}
