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
    struct Constants {
        static let registrationUrl = URL(string: "http://localhost:8080/api/users/register")!
    }
    
    static let shared: AccountManager = AccountManager()
    
    var user: User?
    
    static func attemptToLogin(username: String?, password: String?, successClosure: SuccessClosure?, failClosure:  FailClosure?) {
        guard let usernameUnwrapped = username, let passwordUnwrapped = password, let auth = "\(usernameUnwrapped):\(passwordUnwrapped)".data(using: .utf8)?.base64EncodedString() else {
            failClosure?(nil)
            return
        }
        
        let url = URL(string: "http://localhost:8080/permissions/\(usernameUnwrapped)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                failClosure?(error)
                return
            }
            
            AccountManager.shared.user = User(username: usernameUnwrapped, password: passwordUnwrapped, permissions: nil)
            
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
        
        var request = URLRequest(url: Constants.registrationUrl)
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
