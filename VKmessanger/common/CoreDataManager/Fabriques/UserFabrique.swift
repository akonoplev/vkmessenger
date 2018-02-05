//
//  UserFabrique.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 17.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import CoreData

class UserFabrique {
    class func setUser(id: Int64, name: String, avatarURL: String, online: Bool, context: NSManagedObjectContext )-> User {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
         let fetchResult = try? context.fetch(fetchRequest) as! [User]
        
        if fetchResult!.count == 0 {
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            user.id = id
            user.name = name
            user.avatarURL = avatarURL
            user.online = online
            return user
        } else {
            let user = fetchResult![0]
            user.name = name
            user.avatarURL = avatarURL
            user.online = online
            return user
            
        }
    }
    
    class func getUser(id: Int64, context: NSManagedObjectContext)-> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResult = try? context.fetch(fetchRequest) as! [User]
        return fetchResult?.count == 0 ? nil : fetchResult![0]
    }
}
