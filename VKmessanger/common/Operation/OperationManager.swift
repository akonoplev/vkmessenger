//
//  OperationManager.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 23.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

class OperationManager {
    private static var operationQueue = OperationQueue()
    
    static func addOperation(op: Operation,cancelingQueue cancelFlag: Bool) {
        operationQueue.maxConcurrentOperationCount = 1
        
        if cancelFlag {
            operationQueue.cancelAllOperations()
        }
        operationQueue.addOperation(op)
    }
}
