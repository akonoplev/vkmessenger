//
//  DialogsFabrique.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 09.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import CoreData

class DialogsFabrique {
    class func setDialogs(id:Int64, snippet: String, timestamp: Date, users: [Int64], senderID: Int64, title: String,multiChatURL: String , type: String, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResult = try? context.fetch(fetchRequest) as! [Dialog]
        if fetchResult!.count == 0 {
            let dialog = NSEntityDescription.insertNewObject(forEntityName: "Dialog", into: context) as! Dialog
            dialog.id = id
            dialog.snippet = snippet
            dialog.timestamp = timestamp
            dialog.users = users as NSObject
            dialog.senderID = senderID
            dialog.title = title
            dialog.type = type
            dialog.miltiChatURL = multiChatURL
        } else {
            let dialog = fetchResult![0]
            dialog.snippet = snippet
            dialog.timestamp = timestamp
            dialog.users = users as NSObject
            dialog.senderID = senderID
            dialog.title = title
            dialog.type = type
            dialog.miltiChatURL = multiChatURL
        }
    }
    
    class func getDialog(id: Int64, context: NSManagedObjectContext)-> Dialog? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        let fetchResult = try? context.fetch(fetchRequest) as! [Dialog]
        return fetchResult?.count == 0 ? nil: fetchResult![0]
    }
}
