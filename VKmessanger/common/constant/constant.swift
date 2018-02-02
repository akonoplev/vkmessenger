//
//  constant.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 05.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

struct const {
    struct auth_service {
        static let permissions = ["friends","messages"]
        static let appId = "6321129"
        static let accessToken = ""
    }
    
    struct API {
        static let url = "https://api.vk.com/method/"
    }
}
