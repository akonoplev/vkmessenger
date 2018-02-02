//
//  CoreDataService.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 19.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService: NSObject {
    class func setUserInfo(context: NSManagedObjectContext)-> String {
        var users = String()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let fetchResault = try? context.fetch(fetchRequest) as! [User]
        for user in fetchResault! {
            users = users + "\(user.id),"
            }
        _ = users.dropLast()
        return users
    }
}
