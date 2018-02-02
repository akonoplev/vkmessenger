//
//  DialogsVC.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 05.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class DialogsVC: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    var presenter = DialogsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //presenter.frc.delegate = self
        navigationItem.title = "Диалоги"
        registerNibs()
        presenter.getDialogsFromServer()
    }
    
}


//MARK: delegate and datasource
extension DialogsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfIndex()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogCell", for: indexPath) as! DialogCell
        cell.configure(dialog: presenter.entityAt(index: indexPath) as! Dialog )
        return cell
    }
}

//MARK: fetchResultsController

//extension DialogsVC: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//       tableView.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
//}

//MARK: - other func
extension DialogsVC {
    func registerNibs() {
        let nib = UINib(nibName: "DialogCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "dialogCell")
    }
}
