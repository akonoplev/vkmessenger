//
//  DialogsPresenter.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 09.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import CoreData

class DialogsPresenter: NSObject {
    
    let context = CoreDataManager.sharedInstance.getMainContext()
    weak var viewInput: ViewInput?
    
    lazy var frc: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
         _ = try? frc.performFetch()
        return frc
    }()
}

extension DialogsPresenter: PresenterInput, PresenterOutput {
    func viewLoaded(view: ViewInput) {
        self.viewInput = view
    }
    
    func numberOfIndex()-> Int {
        return frc.fetchedObjects?.count ?? 0
    }
    
    func entityAt(index: IndexPath) -> Any? {
        return frc.object(at:index)
    }
}

extension DialogsPresenter {
    
    func getDialogsFromServer() {
        DataProvider.getDialogs(success: {
            CoreDataManager.sharedInstance.saveContext()
            
        }) { (error) in
            print(error)
        }
    }
}

//MARK: - fetch CoreData
extension DialogsPresenter {

}


