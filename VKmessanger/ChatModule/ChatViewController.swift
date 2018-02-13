//
//  ChatViewController.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController {
    
    var presenter: ChatPresenter?
    var chatRouter: ChatRouter?
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        registrate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear(animate: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: view input
extension ChatViewController: ChatViewInputInterface {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()

        }
    }
    
    func scroll(index: Int) {
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(item: index , section: 0), at: .bottom, animated: false)
        }

    }
    
    func handlerError(error: String) {
        
    }
    
}

//MARK: table view delegate and dataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfEntities() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let message = presenter?.entityAt(index: indexPath) as! Message
        if message.out {
            let cell = tableView.dequeueReusableCell(withIdentifier: "outputMessage", for: indexPath) as! OutputMessageCell
            cell.configure(model: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputMessage", for: indexPath) as! InputMessageCell
            cell.configure(model: message)
            return cell
        }
    }
}

//MARK: - fetchResultsController
extension ChatViewController: ChatFrcViewInterface {
    func beginUpdates() {
        self.tableView.beginUpdates()
    }
    
    func endUpdates() {
        self.tableView.endUpdates()
    }
    
    func insert(to newIndexPath: IndexPath?) {
        if let indexPath = newIndexPath {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func update(indexPath: IndexPath?, object: Message) {
        if let indexPath = indexPath {
            if object.out
            {
                let cell = tableView.cellForRow(at: indexPath) as? OutputMessageCell
                cell?.configure(model: object)
            } else {
                let cell = tableView.cellForRow(at: indexPath) as? InputMessageCell
                cell?.configure(model: object)
            }
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
}


//MARK: - work with textField and keyboard
extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func notificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        adjustHeight(show: true, notification: notification)
        self.tableView.scrollToRow(at: IndexPath(item: (presenter?.numberOfEntities())! - 1, section: 0) , at: .bottom, animated: false)
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        adjustHeight(show: false, notification: notification)
        self.tableView.scrollToRow(at: IndexPath(item: (presenter?.numberOfEntities())! - 1, section: 0), at: .bottom, animated: false)
    }
    
    func adjustHeight(show: Bool, notification: Notification) {
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue

        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeHeight = (keyboardFrame.height) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDuration) {
            self.bottomConstraint.constant += changeHeight
            self.view.layoutIfNeeded()

        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        presenter?.sendMessage(message: textField.text ?? "")
        textField.text = ""
    }
}

extension ChatViewController {
    func registrate() {
        textField.delegate = self
        textField.layer.cornerRadius = 20
        navigationItem.title = presenter?.dialog?.title == "" ? (presenter?.dialog?.dialogToUser?.allObjects as! [User])[0].name : presenter?.dialog?.title
        notificationCenter()
        let leftNib = UINib(nibName: "InputMessageCell", bundle: nil)
        self.tableView.register(leftNib, forCellReuseIdentifier: "inputMessage")
        let rightNib = UINib(nibName: "OutputMessageCell", bundle: nil)
        self.tableView.register(rightNib, forCellReuseIdentifier: "outputMessage")
    }
}
