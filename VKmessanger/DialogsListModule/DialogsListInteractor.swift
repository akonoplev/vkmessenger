//
//  DialogsListInteractor.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 31.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

class DialogsListInteractor: DialogsListInteractorInput {
    
    weak var output: DialogsListInteractorOutput?
    func getData(offset: Int) {
        DataProvider.getDialogs(offset: offset, success: {
            self.output?.success()
        }) { (error) in
            self.output?.failure(error: error)
        }
    }
    
    
}
