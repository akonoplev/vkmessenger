//
//  LongPollService.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 13.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class LongPollService {
    class func connectLongPoll(server: String, key: String, ts: Int) {
        _ = API_wrapper.connectLongPolServer(server: server, key: key, timestamp: ts, success: { (response) in
            
            let json = JSON(response)
            let new_ts = json["ts"].intValue
            
            if json["ts"] != JSON.null {
                print("пришло")
                let updates = json["updates"].arrayValue
                for update in updates {
                    if update[0] == 4 {
                        print(update)
                        print("===")
                        let context = CoreDataManager.sharedInstance.getBackgroundContext()
                        let set = NSMutableSet()
                        let message_id = update[1].int64Value
                        let mask = decodeMask(i: update[2].intValue)
                        let chat_id = update[3].int64Value
                        let timestamp = update[4].doubleValue
                        let text = update[5].stringValue
                        let out = mask[1] == 1 ? true : false
                        let read_state = mask[0] == 1 ? true : false
                        
                        let message = MessageFabrique.setMessage(id: message_id, chat_id: chat_id, text: text, date: Date(timeIntervalSince1970: timestamp), out: out, isRead: read_state, context: context)
                        set.add(message)
                        _ = DialogsFabrique.addMessages(DialogId: chat_id, MessagesSet: set, context: context)
                        _ = try? context.save()
                    }
                }
                LongPollService.connectLongPoll(server: server, key: key, ts: new_ts)
            }
                    
        }, failure: { (error) in
            print(error)
        })
    }
    
    class func decodeMask(i: Int)-> [Int] {
        let array = [1,2,4,8,16,32,64,128,256,512]
        var binary = [Int]()
        for b in array {
            if i&b == 0 {
                binary.append(0)
            } else {
                binary.append(1)
            }
        }
        return binary
    }

}
