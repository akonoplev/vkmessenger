//
//  MessageOperation.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 07.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import SwiftyJSON
import CoreData

class MessageOperation: Operation {
    var success: ()-> Void
    var failure: (String)-> Void
    var id: Int64?
    var title = ""
    var offset = 0
    var count = 0
    
    var urlSessionDataTask: URLSessionDataTask?
    
    required init(id: Int64, title: String, offset: Int, count: Int,success: @escaping ()-> Void, failure: @escaping (String)-> Void) {
        self.id = id
        self.title = title
        self.offset = offset
        self.count = count
        self.success = success
        self.failure = failure
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        let backgroundContext = CoreDataManager.sharedInstance.getBackgroundContext()
        _ = API_wrapper.getHistoryMessage(chat_id: id ?? 0, title: title, count: count, offset: offset, success: { (response) in
            
            let json = JSON(response)
            
            let rawItems = json["response"]
            let items = rawItems["items"].arrayValue
            var dialogID: Int64?
            let messageSet = NSMutableSet()
            for item in items {
                let id = item["id"].int64
                
                let user_id = item["user_id"].int64Value
                let read_state = item["read_state"].boolValue
                let body = item["body"].stringValue
                let date = item["date"].doubleValue
                let out = item["out"].boolValue
                
                let message = MessageFabrique.setMessage(id: id ?? 0, chat_id: user_id, text: body, date: Date(timeIntervalSince1970: date), out: out, isRead: read_state, context: backgroundContext)
                
                messageSet.add(message)
            }
            
            if self.isCancelled {
                self.success()
            } else {
                dialogID = self.getDialogId(id: self.id!)
                DialogsFabrique.addMessages(DialogId: dialogID! , MessagesSet: messageSet, context: backgroundContext)
                _ = try? backgroundContext.save()
                self.success()
            }
            
            _ = semaphore.signal()
        }, failure: { (error) in
            self.failure(error)
            _ = semaphore.signal()
        })
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    private func getDialogId(id: Int64)-> Int64 {
        let iD = id > 2000000000 ?  id - 2000000000 : id
        return iD

    }
}


