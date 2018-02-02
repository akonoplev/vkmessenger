//
//  ViewInput.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 09.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

protocol ViewInput: class {
    func reloadData()
    func assign(presenterInput: PresenterInput, presenterOutput: PresenterOutput)
}
