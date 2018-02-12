//
//  DialogsListViewController.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 31.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class DialogsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: DialogsListPresenter?
    var router: DialogsListRouter?
    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Диалоги"
        registrate()
        presenter?.viewDidLoad()
        refreshControl()
        }
}

extension DialogsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfEntities() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogCell", for: indexPath) as! DialogCell
        cell.configure(dialog: presenter?.entityAt(index: indexPath) as! Dialog)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (presenter?.numberOfEntities() ?? 0 ) - 15 {
            presenter?.getData(offset: presenter?.numberOfEntities() ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.showChat(chat: (presenter?.entityAt(index: indexPath) as! Dialog))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension DialogsListViewController: DialogsListViewInterface {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
        }
        
    }
    
    func handleInternetError(error: String) {
    }
}

extension DialogsListViewController {
    func registrate() {
        let nib = UINib(nibName: "DialogCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "dialogCell")
    }
    
    func refreshControl() {
        refreshController.attributedTitle = NSAttributedString(string: "Обновление")
        refreshController.addTarget(self, action: #selector(presenter?.viewDidLoad), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshController)
    }
}

//MARK: - frc

extension DialogsListViewController: DialogsListFrcViewChange {
    func beginUpdates() {
        tableView.beginUpdates()
    }
    
    func insert(to newIndexPath: IndexPath?) {
        if let indexPath = newIndexPath {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func update(indexPath: IndexPath?, object: Dialog) {
        if let indexPath = indexPath {
            let cell = tableView.cellForRow(at: indexPath) as? DialogCell
            cell?.configure(dialog: object)
        }
    }
    
    func move(from indexPath: IndexPath?, to newIndexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        if let newIndexPath = newIndexPath {
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    func delete(indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
}


