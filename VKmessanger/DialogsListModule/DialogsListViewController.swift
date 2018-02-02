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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Диалоги"
        registrate()
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
}


extension DialogsListViewController: DialogsListViewInterface {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func handleInternetError(error: String) {
    }
}

extension DialogsListViewController {
    func registrate() {
        let nib = UINib(nibName: "DialogCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "dialogCell")
    }
}

