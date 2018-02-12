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
        _ = API_wrapper.sendMessage(chat_id: self.chat_id ?? 0, message: self.message ?? "", random_id: self.random_id ?? 0, success: { (response) in
            let json = JSON(response)
            print(json)
            
            _ = semaphore.signal()
        }) { (error) in
            print(error)
            _ = semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
}
