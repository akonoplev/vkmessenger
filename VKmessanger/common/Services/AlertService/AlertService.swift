//
//  AlertService.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 23.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    class func setAlert(vc: UIViewController,alert:  String) {
        let alertController = UIAlertController(title: "Ошибка", message:  alert, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        vc.present(alertController, animated: true, completion: nil)
    }
}
