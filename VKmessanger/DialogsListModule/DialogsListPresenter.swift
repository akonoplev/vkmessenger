//
//  DialogsListPresenter.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 31.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import CoreData

class DialogsListPresenter: DialogsListPresenterInterface {
    
    weak var view: DialogsListViewInterface?
    var interactor: DialogsListInteractorInput?
    
    lazy var frc: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        _ = try? frc.performFetch()
        return frc
    }()
    
    func viewDidLoad() {
        interactor?.getData()
    }
    
    func viewWillAppear(animated: Bool) {
        
    }
    
    func viewDidAppear(animated: Bool) {
        
    }
    
    func numberOfEntities() -> Int {
       return frc.fetchedObjects?.count ?? 0
    }
    
    func entityAt(index: IndexPath) -> Any? {
        return frc.object(at:index)
    }
}

extension DialogsListPresenter: DialogsListInteractorOutput {
    func success() {
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func failure(error: String) {
        print(error)
    }
    
    
}
