//
//  ChatInteractor.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation


class ChatInteractor: ChatInteractorInput {
    
    weak var output: ChatInteractorOutput?
    
    func getData(id: Int64, title: String, offset: Int, count: Int) {
        DataProvider.getMessagesHistory(id: id, title: title, offset: offset, count: count, success: {
            CoreDataManager.sharedInstance.saveContext()
            self.output?.success()
        }) { (error) in
            self.output?.failure(error: error)
        }
    }
    
    func sendMessage(id: Int64, random_id: Int, message: String) {
        
    }
    



}
