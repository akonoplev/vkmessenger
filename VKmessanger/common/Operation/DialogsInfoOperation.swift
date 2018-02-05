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
    var offset = 0
    var user: User?
    var dialog: Dialog?
    
    var urlSessionDataTask: URLSessionDataTask?
    
    init(offset: Int ,success: @escaping ()-> Void, failure: @escaping (String)-> Void) {
        self.success = success
        self.failure = failure
        self.offset = offset
        super.init()
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        _ = API_wrapper.getDialogs(offset: self.offset, success: { (response) in
            let backgroundContext = CoreDataManager.sharedInstance.getBackgroundContext()
            let json = JSON(response)
            let rawItems = json["response"]
            let items = rawItems["items"].arrayValue
            
            var usersArray = ""
            
            
            for dialog in items {
                let message = dialog["message"]
                let chatID = message["chat_id"].int64Value
                var multichatURL = "empty"
                let senderUserID = message["user_id"].int64Value
                let title = message["title"].stringValue
                let isRead = message["read_state"].boolValue
                let out = message["out"].boolValue
                var body = message["body"].stringValue
                
                if message["photo_100"] != JSON.null {
                    multichatURL = message["photo_100"].stringValue
                }
                
                let date = message["date"].doubleValue
                
                if body == "" {
                    let attachment = message["attachments"].arrayValue
                    var tempBody = ""
                    
                    for attach in attachment {
                        let type = attach["type"].stringValue
                        
                        switch type {
                        case "photo": tempBody = "Фотография"
                        case "video": tempBody = "Видео"
                        case "audio": tempBody = "Аудиозапись"
                        case "doc": tempBody = "Документ"
                        case "link": tempBody = "Ссылка"
                        case "market": tempBody = "Товар"
                        case "market_album": tempBody = "Подборка товаров"
                        case "wall": tempBody = "Запись со стены"
                        case "wall_reply": tempBody = "Коментарий на стене"
                        case "sticker": tempBody = "Стикер"
                        case "gift": tempBody = "Подарок"
                            
                        default: tempBody = "Пересланое сообщение"
                        }
                        body = tempBody
                    }
                    
                }
                
                if chatID != 0 {
                     let chatUsers = message["chat_active"].arrayValue
                    for userInChat in chatUsers {
                        let user = userInChat.int64Value
                        usersArray += "\(user),"
                        self.setObjects(id: user, chatID: chatID, senderId: senderUserID, title: title, isRead:isRead , out: out, userId: user, timestamp: Date(timeIntervalSince1970: date), snippet: body , multichatAvatar: multichatURL, context: backgroundContext)
                    }
                } else {
                    usersArray += "\(senderUserID),"
                    self.setObjects(id: senderUserID, chatID: senderUserID, senderId: senderUserID, title: title, isRead: isRead, out: out, userId: senderUserID, timestamp: Date(timeIntervalSince1970: date) , snippet: body, multichatAvatar: multichatURL, context: backgroundContext)
                }
                
            }
            
            if self.isCancelled {
                self.success()
                _ = semaphore.signal()
            } else {
                self.getUsers(ids: usersArray, semaphore: semaphore, backgroundContext: backgroundContext)
            }
            
        }, failure: { (error) in
            self.failure(error)
            _ = semaphore.signal()
        })
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    func getUsers(ids: String, semaphore: DispatchSemaphore, backgroundContext: NSManagedObjectContext) {
        _ = ids.dropLast()
        _ = API_wrapper.getUserInfo(id: ids, success: { (response) in
            let infoJson = JSON(response)
            let arrayInfo = infoJson["response"].arrayValue
            for param in arrayInfo {
                let id = param["id"].int64Value
                let name = "\(param["first_name"].stringValue) \(param["last_name"].stringValue)"
                let online = param["online"].boolValue
                let avatarURL = param["photo_50"].stringValue
                
               _ = UserFabrique.setUser(id: id, name: name, avatarURL: avatarURL, online: online, context: backgroundContext)
            }
            _ = try? backgroundContext.save()
            self.success()
            _ = semaphore.signal()

        }, failure: { (error) in
            print(error)
        })
    }
    
    func setObjects(id: Int64, chatID: Int64, senderId: Int64, title: String, isRead: Bool, out: Bool, userId: Int64, timestamp: Date, snippet: String, multichatAvatar: String, context: NSManagedObjectContext ) {
        
        self.dialog = DialogsFabrique.setDialogs(id: chatID, snippet: snippet, timestamp: timestamp, senderID: senderId, title: title, multiChatURL: multichatAvatar, out: out, isRead: isRead, context: context)
        self.user = UserFabrique.setUser(id: id, name: "", avatarURL: "", online:
            false, context: context)
        
        user?.addToUserToDialog(self.dialog!)
        dialog?.addToDialogToUser(self.user!)
        
        
    }
}
