//
//  DialogsListPresenter.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 31.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import CoreData

class DialogsListPresenter: NSObject, DialogsListPresenterInterface {

    weak var view: DialogsListViewInterface?
    weak var viewFrc: DialogsListFrcViewChange?
    var interactor: DialogsListInteractorInput?
    
    lazy var frc: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        _ = try? frc.performFetch()
        return frc
    }()
    
    @objc func viewDidLoad() {
        frc.delegate = self
        interactor?.getData(offset: 0)
    }

    func viewWillAppear(animated: Bool) {
        
    }
    
    func viewDidAppear(animated: Bool) {
        
    }
    
    func getData(offset: Int) {
        interactor?.getData(offset: offset)
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
        DispatchQueue.main.async {
            CoreDataManager.sharedInstance.saveContext()
            self.view?.reloadData()
        }
    }
    
    func failure(error: String) {
        print(error)
        self.view?.reloadData()
    }
}

//MARK: - frc
extension DialogsListPresenter: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.viewFrc?.beginUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            switch type {
            case .insert:
                self.viewFrc?.insert(to: newIndexPath)
            case .update:
                self.viewFrc?.update(indexPath: indexPath, object: self.frc.object(at: indexPath!) as! Dialog)
            case .move:
                self.viewFrc?.move(from: indexPath, to: newIndexPath)
            case .delete:
                self.viewFrc?.delete(indexPath: indexPath)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.viewFrc?.endUpdates()
        }
        
    }
}
