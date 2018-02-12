//
//  ChatPresenter.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import CoreData


class ChatPresenter: NSObject {
    
    weak var view: ChatViewInputInterface?
    weak var viewFrc: ChatFrcViewInterface?
    var interactor: ChatInteractorInput?
    
    var dialog: Dialog?
    var dialogIsEmpty = true

    
    var frc: NSFetchedResultsController<NSFetchRequestResult>?

    
    required init(chat: Dialog) {
        self.dialog = chat
    }
    
    func setUpFRC() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "messageToDialog.id=%lld", (dialog?.id)!)
        fetchRequest.predicate = predicate
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        _ = try? frc.performFetch()
        self.frc = frc
    }
    
}


extension ChatPresenter: ChatPresenterInterface {
    func viewDidLoad() {
        

    }
    
    func viewWillAppear(animate: Bool) {
        if DialogsFabrique.hasMessages(id: (self.dialog?.id)!, context: CoreDataManager.sharedInstance.getMainContext()) {
            dialogIsEmpty = true
            setUpFRC()
            view?.reloadData()
        }
        
        getData(offset: 0)
    }
    
    func getData(offset: Int) {
        self.interactor?.getData(id: self.dialog?.id ?? 0, title: self.dialog?.title ?? "", offset: 0, count: const.chatParams.countMessages)
    }
    
    func sendMessage(message: String) {
        self.interactor?.sendMessage(id: self.dialog?.id ?? 0, random_id: Int(arc4random()), message: message)
    }
    
    func numberOfEntities() -> Int {
        if frc == nil {
            return 0
        } else {
            return frc!.fetchedObjects!.count
        }
    }
    
    func entityAt(index: IndexPath) -> Any? {
        if frc == nil {
            return nil
        } else {
            return frc?.object(at: index)
        }
    }
}


extension ChatPresenter: ChatInteractorOutput {
    func success() {
        if dialogIsEmpty {
            setUpFRC()
            view?.reloadData()
            dialogIsEmpty = false
        }

    }
    
    func failure(error: String) {
        print(error)
    }
}

//MARK: - fetchResultsController delegate
extension ChatPresenter: NSFetchedResultsControllerDelegate {
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
                self.viewFrc?.update(indexPath: indexPath, object: self.frc?.object(at: indexPath!) as! Message)
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
