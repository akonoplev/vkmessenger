//
//  ChatPresenter.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation


class ChatPresenter {
    
    weak var view: ChatViewInputInterface?
    weak var viewFrc: ChatFrcViewInterface?
    var interactor: ChatInteractorInput?
    
    var chat_id: Int64?
    
    required init(chat_id: Int64) {
        self.chat_id = chat_id
    }
    
}

extension ChatPresenter: ChatInteractorInput {
    
    func getData() {
        
    }
    
    
}

extension ChatPresenter: ChatInteractorOutput {
    func success() {
        
    }
    
    func failure() {
        
    }
    
    
}
