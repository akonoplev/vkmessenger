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
        textField.delegate = self
        textField.layer.cornerRadius = 20
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.tableView.scrollToRow(at: IndexPath(item: 99, section: 0), at: .bottom, animated: false)
    }
}

extension ChatViewController: ChatViewInputInterface {
    func reloadData() {
        
    }
    
    func handlerError(error: String) {
        
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

extension ChatViewController: ChatFrcViewInterface {
    func beginUpdates() {
        
    }
    
    func endUpdates() {
        
    }
    
    func insert(to newIndexPath: IndexPath?) {
        
    }
    
    func update(indexPath: IndexPath?, object: Message) {
        
    }
    
    func move(from indexPath: IndexPath?, to newIndexPath: IndexPath?) {
        
    }
    
    func delete(indexPath: IndexPath?) {
        
    }
}

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        adjustHeight(show: true, notification: notification)
        self.tableView.scrollToRow(at: IndexPath(item: 99, section: 0) , at: .bottom, animated: false)
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        adjustHeight(show: false, notification: notification)
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
}
