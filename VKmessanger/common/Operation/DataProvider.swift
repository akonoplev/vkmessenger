//
//  DataProvider.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 23.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

class DataProvider {
    class func getDialogs(offset: Int, success: @escaping ()-> Void, failure: @escaping (_ errorDescription: String)-> Void) {
        let operation = DialogsInfoOperation(offset: offset, success: success, failure: failure)
        OperationManager.addOperation(op: operation, cancelingQueue: true)
    }
    
    class func getMessagesHistory(id: Int64, title: String, offset: Int, count: Int, success: @escaping ()-> Void, failure: @escaping (_ error: String)-> Void) {
        let operation = MessageOperation(id: id, title: title, offset: offset, count: count, success: success, failure: failure)
        OperationManager.addOperation(op: operation, cancelingQueue: true)
    }
    
    class func sendMessange(chat_id: Int64, message: String, random_id: Int, success: @escaping ()-> Void, failure: @escaping (_ error: String)-> Void) {
        let operation = SendMessageOperation(message: message, chat_id: chat_id, random_id: random_id, success: success, failure: failure)
        OperationManager.addOperation(op: operation, cancelingQueue: true)
    }
}
