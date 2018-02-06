//
//  AuthViewController.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 30.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import SwiftyJSON

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        VKMAuthService.sharedInstance.auth(controller: self, success: {
            
            if ProfileService.sharedInstance.getName() == "d" {
                ProfileService.sharedInstance.setProfile()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
            {
               // self.performSegue(withIdentifier: "loginSuccess", sender: self)
                let navController = UINavigationController()
                let router = DialogsListRouter()
                navController.setViewControllers([router.setUpModule()], animated: false)
                self.present(navController, animated: true, completion: nil)
            }
            
            
            
        }, failure: { [weak self] in
            
            let alertController = UIAlertController(title: nil, message: "К сожалению, произошёл обоссамс автризации. Разработчик уволен", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alertController.addAction(action)
            self?.present(alertController, animated: true, completion: nil)
            
            
        })
        super.viewDidAppear(animated)
        VKMAuthService.sharedInstance.success = {
            print("ХЕР")
        }
    }
}
