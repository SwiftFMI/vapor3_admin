//
//  ServerRequestManager.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation

final class ServerRequestManager {
    struct Constants {
        struct Url {
            static let registration   =  URL(string: "http://localhost:8080/api/users/register")!
            static let createCategory =  URL(string: "http://localhost:8080/category/create")!
            static let category       =  URL(string: "http://localhost:8080/category")!
        }
    }
    
    static func createCategory(_ jsonData: Data?, completion: @escaping (Bool) -> ()) {
        guard let auth = "\(AccountManager.shared.user?.username ?? ""):\(AccountManager.shared.user?.password ?? "")".data(using: .utf8)?.base64EncodedString() else {
            print("generic error")
            completion(false)
            return
        }
        
        var request = URLRequest(url: ServerRequestManager.Constants.Url.createCategory)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "generic error")
                completion(false)
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString ?? "generic response")
            completion(true)
        }
        
        task.resume()
    }
    
    static func fetchCategories(completion: @escaping (Bool) -> ()) {
        guard let auth = "\(AccountManager.shared.user?.username ?? ""):\(AccountManager.shared.user?.password ?? "")".data(using: .utf8)?.base64EncodedString() else {
            print("generic error")
            completion(false)
            return
        }
        
        var request = URLRequest(url: ServerRequestManager.Constants.Url.category)
        request.httpMethod = "POST"
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "generic error")
                completion(false)
                return
            }
            
            AccountManager.shared.categories = try? JSONDecoder().decode([Category].self, from: data)
            print("Categories content: \(AccountManager.shared.categories)")
            completion(true)
        }
        
        task.resume()
    }
}
