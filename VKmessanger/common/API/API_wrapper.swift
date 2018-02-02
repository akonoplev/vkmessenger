//
//  API_wrapper.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 06.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

class API_wrapper {
    //MARK: get Dialogs
    class func getDialogs(success: @escaping (_ json: Any)->Void, failure: @escaping (_ errorDescription: String)-> Void)-> URLSessionTask {
        let url = const.API.url + "messages.getDialogs"
        let params: [String: Any] = [
            "count": 50,
            "unread": 0,
            "important": 0,
            "unanswered": 0,
            "access_token": VKMAuthService.sharedInstance.getAccessToken(),
            "v": 5.69 ]
        
        let request = API_conf.getRequst(url: url, params: params)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, requestError) in
            API_conf.acceptDataFromServer(data: data, RequestError: requestError, success: success, failure: failure)
        }
        
        dataTask.resume()
        return dataTask
    }
    
    //MARK: getUserInfo
    class func getUserInfo(id: String, success: @escaping (_ json: Any)->Void , failure: @escaping (_ error: String)->())-> URLSessionTask {
        let url = const.API.url + "users.get"
        let params: [String: Any] = [
            "user_ids": id,
            "fields": "photo_50,online",
            "name_case": "Nom",
            "access_token": VKMAuthService.sharedInstance.getAccessToken(),
            "v": 5.71]
        let request = API_conf.getRequst(url: url, params: params)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, requestError) in
            API_conf.acceptDataFromServer(data: data, RequestError: requestError, success: success, failure: failure)
            
        }
        dataTask.resume()
        return dataTask
    }
}
