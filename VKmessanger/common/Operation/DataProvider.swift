//
//  DataProvider.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 23.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

class DataProvider {
    class func getDialogs(success: @escaping ()-> Void, failure: @escaping (_ errorDescription: String)-> Void) {
        let operation = DialogsInfoOperation(success: success, failure: failure)
        OperationManager.addOperation(op: operation, cancelingQueue: true)
    }
}