//
//  MessageFabrique.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 17.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import CoreData

class MessageFabrique {
    class func setMessage(id: Int64, text: String?, date: Date?, inbox: Bool, isRead: Bool, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResult = try? context.fetch(fetchRequest) as! [Message]
        
        if fetchResult!.count == 0 {
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.id = id
            message.text = text
            message.date = date
            message.inbox = inbox
            message.isRead = isRead
        }
    }
    
    class func getMessage(id: Int64, context: NSManagedObjectContext) -> Message? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        let fetchResult = try? context.fetch(fetchRequest) as! [Message]
        return fetchResult?.count == 0 ? nil: fetchResult![0]
    }
    
    
}
