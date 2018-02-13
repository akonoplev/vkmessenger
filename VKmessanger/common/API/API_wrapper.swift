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
    class func getDialogs(offset: Int, success: @escaping (_ json: Any)->Void, failure: @escaping (_ errorDescription: String)-> Void)-> URLSessionTask {
        let url = const.API.url + "messages.getDialogs"
        let params: [String: Any] = [
            "offset": offset,
            "count": 40,
            "unread": 0,
            "important": 0,
            "unanswered": 0,
            "access_token": VKMAuthService.sharedInstance.getAccessToken(),
            "v": 5.71]
        
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
    
    //MARK: - get message history
    class func getHistoryMessage(chat_id: Int64, title: String,count: Int, offset: Int, success: @escaping (_ json: Any)-> Void,failure: @escaping (_ error: String)-> Void)-> URLSessionTask{
        
        let url = const.API.url + "messages.getHistory"
        let request_id = title == "" ? "user_id"  : "peer_id"
        let id = request_id == "peer_id" ? 2000000000 + chat_id : chat_id
        let params: [String:Any] = [
            "count": count,
            "offset": offset,
            request_id: id,
            "access_token": VKMAuthService.sharedInstance.getAccessToken() ,
            "v": 5.71]
        
        let request = API_conf.getRequst(url: url, params: params)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, requestError) in
            API_conf.acceptDataFromServer(data: data, RequestError: requestError, success: success, failure: failure)
        }
        
        dataTask.resume()
        return dataTask
        
    }
}

extension API_wrapper {
    //getProfileInfo
    class func getProfileInfo(success: @escaping (_ json: Any)-> Void, failure: @escaping (_ error: String)-> Void)-> URLSessionTask {
        let url = const.API.url + "account.getProfileInfo"
        let params: [String: Any] = [
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

//MARK: LongPoll
extension API_wrapper {
    class func getLongPollServer(success: @escaping (_ json: Any)-> Void, failure: @escaping (_ error: String)-> Void )-> URLSessionTask {
        let url = const.API.url + "messages.getLongPollServer"
        let params: [String: Any] = [
            "need_pts": 1,
            "lp_version": 2,
            "access_token": VKMAuthService.sharedInstance.getAccessToken(),
            "v": 5.73]
        
        let request = API_conf.getRequst(url: url, params: params)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            API_conf.acceptDataFromServer(data: data, RequestError: error, success: success, failure: failure)
        }
        
        dataTask.resume()
        return dataTask
    }
    
    class func connectLongPolServer(server: String, key: String, timestamp: Int, success: @escaping (_ json: Any)-> Void, failure: @escaping (_ error: String)-> Void)-> URLSessionTask {
        let url = "http://\(server)"
        let params: [String: Any] = [
            "act": "a_check",
            "key": key,
            "ts": timestamp,
            "wait": 25,
            "mode": 2,
            "version": 2]
        
        let request = API_conf.getRequst(url: url, params: params)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            API_conf.acceptDataFromServer(data: data, RequestError: error, success: success, failure: failure)
            }
        dataTask.resume()
        return dataTask
}
    
    class func sendMessage(chat_id: Int64, message: String, random_id: Int, success: @escaping (_ json: Any)-> Void, failure: @escaping (_ error: String)-> Void)-> URLSessionTask {
        
        let encodeMessage = message.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = const.API.url + "messages.send"
        let params: [String: Any] = [
            "peer_id": chat_id,
            "random_id": random_id,
            "message": encodeMessage ?? "",
            "access_token": VKMAuthService.sharedInstance.getAccessToken(),
            "v": 5.71 ]
        let request = API_conf.getRequst(url: url, params: params)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            API_conf.acceptDataFromServer(data: data, RequestError: error, success: success, failure: failure)
        }
        
        dataTask.resume()
        return dataTask
    }
}
