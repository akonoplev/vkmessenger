//
//  DialogsInfoOperation.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 23.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class DialogsInfoOperation: Operation {
    var success: ()-> Void
    var failure: (String) -> Void
    
    var urlSessionDataTask: URLSessionDataTask?
    
    init(success: @escaping ()-> Void, failure: @escaping (String)-> Void) {
        self.success = success
        self.failure = failure
        super.init()
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        _ = API_wrapper.getDialogs(success: { (response) in
            let backgroundContext = CoreDataManager.sharedInstance.getBackgroundContext()
            let json = JSON(response)
            var unknowUser = ""
            for dialog in json["response"]["items"].arrayValue {
                
                let messageBody = dialog["message"].dictionary
//                                print("============")
//                                print(dialog)
                guard let message = messageBody else { return }
                var id =  message["chat_id"]?.int64Value
                var type = "chat"
                if id == nil {
                    id = message["id"]?.int64Value
                    type = "dialog"
                    
                }
                
                var users = [Int64]()
                let body = message["body"]?.stringValue
               // let read_state = message["read_state"]?.boolValue
                let date = message["date"]?.doubleValue
               // let out = message["out"]?.boolValue
                var sender_id = message["user_id"]?.int64Value
                let user_id = message["user_id"]?.arrayValue
                let title = message["title"]?.stringValue
                var multiChatURL = message["photo_100"]?.stringValue
                
                for user in user_id! {
                    users.append(user.int64Value)
                }
                
                
                if type == "chat" {
                    let chat_users = message["chat_active"]?.arrayValue
                    sender_id = message["id"]?.int64Value
                    for user_id in chat_users! {
                       users.append(user_id.int64Value)
                    
                    }
                }
                
                DialogsFabrique.setDialogs(id: id ?? 0, snippet: body ?? "", timestamp: Date(timeIntervalSince1970: date ?? 0), users: users , senderID: sender_id ?? 0, title: title ?? "", multiChatURL: multiChatURL ?? "", type: type, context: CoreDataManager.sharedInstance.getMainContext())
                
                UserFabrique.setUser(id: sender_id ?? 0, name: nil, avatarURL: nil, online: false, context: CoreDataManager.sharedInstance.getMainContext())
                
                let dialogue = DialogsFabrique.getDialog(id: id ?? 0, context: backgroundContext)
                
                if dialogue?.type == "dialog" {
                    let user = UserFabrique.getUser(id: sender_id ?? 0, context: backgroundContext)
                    if user == nil {
                        unknowUser += String(describing: user_id) + ","
                        
                    } else {
                        user?.addToUserToDialog(dialogue!)
                        dialogue?.addToDialogToUser(user!)
                    }
                } else if dialogue?.type == "chat" {
                    for user in dialogue?.users as! [Int64] {
                        let chat_user = UserFabrique.getUser(id: user, context: backgroundContext)
                        if chat_user == nil {
                            unknowUser += String(describing: user_id) + ","
                        } else {
                            chat_user?.addToUserToDialog(dialogue!)
                            dialogue?.addToDialogToUser(chat_user!)
                        }
                    }
                }
            }
            
            if self.isCancelled {
                self.success()
                _ = semaphore.signal()
            } else {
                self.getUsers(ids: CoreDataService.setUserInfo(context: backgroundContext ), semaphore: semaphore, backgroundContext: backgroundContext)
            }
            
        }, failure: { (error) in
            self.failure(error)
            _ = semaphore.signal()
        })
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    func getUsers(ids: String, semaphore: DispatchSemaphore, backgroundContext: NSManagedObjectContext) {
        _ = API_wrapper.getUserInfo(id: ids, success: { (response) in
            let infoJson = JSON(response)
            let arrayInfo = infoJson["response"].arrayValue
            for param in arrayInfo {
                let id = param["id"].int64Value
                let name = "\(param["first_name"].stringValue) \(param["last_name"].stringValue)"
                let online = param["online"].boolValue
                let avatarURL = param["photo_50"].stringValue
                
                UserFabrique.setUser(id: id, name: name, avatarURL: avatarURL, online: online, context: backgroundContext)
            }
            _ = semaphore.signal()
            _ = try? backgroundContext.save()
            self.success()
        }, failure: { (error) in
            print(error)
        })
    }
}
