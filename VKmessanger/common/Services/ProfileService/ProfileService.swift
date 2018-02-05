//
//  File.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import SwiftyJSON


class ProfileService: NSObject {
    
    private var name = "d"
    private var id = "d"
    private var avatarURL = "d"
    
    static let sharedInstance = ProfileService()
    
    func setProfile() {
        _ = API_wrapper.getProfileInfo(success: { (response) in
            let profileInfo = JSON(response)
            let first_name = profileInfo["response"]["first_name"].stringValue
            let last_name = profileInfo["response"]["last_name"].stringValue
            let screen_name = profileInfo["response"]["screen_name"].stringValue
            
            self.name = first_name + " " + last_name
            self.id = screen_name
            
            _ = API_wrapper.getUserInfo(id: self.id, success: { (response) in
                
                let infoJson = JSON(response)
                let arrayInfo = infoJson["response"].arrayValue
                for param in arrayInfo {
//                    let id = param["id"].int64Value
//                    let name = "\(param["first_name"].stringValue) \(param["last_name"].stringValue)"
//                    let online = param["online"].boolValue
                    let avatarURL = param["photo_50"].stringValue
                    self.avatarURL = avatarURL

                }
            }, failure: { (error) in
                print(error)
            })
            
        }) { (error) in
            print(error)
        }
    }
    
    func getName()-> String {
        return self.name
    }
    
    func getAvatarUrl()-> String {
        return self.avatarURL
    }
    
}
