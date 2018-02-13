//
//  SendMessageOperation.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 12.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import SwiftyJSON


class SendMessageOperation: Operation {
    var message: String?
    var chat_id: Int64?
    var random_id: Int?
    var success: ()-> Void
    var failure: (_ error: String)-> Void
    
    var urlSessionDataTask: URLSessionDataTask?
    
    required init(message: String, chat_id: Int64, random_id: Int, success: @escaping ()-> Void, failure: @escaping (_ error: String)-> Void) {
        self.message = message
        self.chat_id = chat_id
        self.random_id = random_id
        self.success = success
        self.failure = failure
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        let backgroundContext = CoreDataManager.sharedInstance.getBackgroundContext()
        _ = API_wrapper.sendMessage(chat_id: self.chat_id ?? 0, message: self.message ?? "", random_id: self.random_id ?? 0, success: { (response) in
            let messageSet = NSMutableSet()
            let json = JSON(response)
            let message_id = json["response"].int64Value
            let message = MessageFabrique.setMessage(id: message_id, chat_id: self.chat_id!, text: self.message!, date: Date(), out: true, isRead: false, context: backgroundContext )
            messageSet.add(message)
            
            DialogsFabrique.addMessages(DialogId: self.chat_id!, MessagesSet: messageSet, context: backgroundContext)
            _ = try? backgroundContext.save()
            self.success()
            _ = semaphore.signal()
        }) { (error) in
            print(error)
            self.failure(error)
            _ = semaphore.signal()
            
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
}
