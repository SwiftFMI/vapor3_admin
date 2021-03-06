//
//  AccountManager.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation

typealias SuccessClosure = (String?) -> ()
typealias FailClosure = (Error?) -> ()

class AccountManager {
    
    static let shared: AccountManager = AccountManager()
    static let authentication: String = {
        guard let user = AccountManager.shared.user else {
            return ""
        }
        
        let loginString = "\(user.username):\(user.password)"
        
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return ""
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        return "Basic \(base64LoginString)"
    }()
    
    var user: User?
    
    static func attemptToLogin(username: String?, password: String?, successClosure: SuccessClosure?, failClosure:  FailClosure?) {
        guard let usernameUnwrapped = username, let passwordUnwrapped = password else {
            failClosure?(nil)
            return
        }
        
        AccountManager.shared.user = User(username: usernameUnwrapped, password: passwordUnwrapped, permissions: nil)
        
        let url = URL(string: "http://localhost:8080/permissions/\(usernameUnwrapped)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AccountManager.authentication, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                failClosure?(error)
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            if responseString == "viewer" {
                AccountManager.shared.user?.permissions = .viewer
            } else if responseString == "uploader" {
                AccountManager.shared.user?.permissions = .uploader
            } else if responseString == "admin" {
                AccountManager.shared.user?.permissions = .admin
            }
            
            successClosure?(responseString)
        }

        task.resume()
    }
    
    static func attemptToRegister(username: String?, password: String?, successClosure: SuccessClosure? = nil, failClosure:  FailClosure? = nil) {
        guard let usernameUnwrapped = username, let passwordUnwrapped = password, usernameUnwrapped != "", passwordUnwrapped != "" else {
            failClosure?(nil)
            return
        }
        
        var request = URLRequest(url: ServerRequestManager.Constants.Url.registration)
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["username": usernameUnwrapped, "password": passwordUnwrapped, "permissions": "viewer"]
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                failClosure?(error)
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            successClosure?(responseString)
        }
        
        task.resume()
    }
}
