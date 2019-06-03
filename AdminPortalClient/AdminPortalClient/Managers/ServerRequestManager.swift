//
//  ServerRequestManager.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation
import Alamofire
import AVFoundation

final class ServerRequestManager {
    struct Constants {
        struct Url {
            static let localhost      =  URL(string: "http://localhost:8080")!
            static let registration   =  URL(string: "http://localhost:8080/api/users/register")!
            static let createCategory =  URL(string: "http://localhost:8080/category/create")!
            static let category       =  URL(string: "http://localhost:8080/category")!
            
            static func uploadVideoIn(category: Category) -> URL? {
                guard let categoryID = category.id else {
                    return nil
                }
                
                var url = localhost
                url.appendPathComponent("addvideo/uuid=\(categoryID.uuidString)")
                return url
            }
        }
    }
    
    static func createCategory(_ jsonData: Data?, completion: @escaping (Bool) -> ()) {
        var request = URLRequest(url: ServerRequestManager.Constants.Url.createCategory)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(AccountManager.authentication, forHTTPHeaderField: "Authorization")
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
    
    static func fetchCategories(completion: @escaping ([Category]?) -> ()) {
        var request = URLRequest(url: ServerRequestManager.Constants.Url.category)
        request.httpMethod = "POST"
        request.setValue(AccountManager.authentication, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil, let categories = try? JSONDecoder().decode([Category].self, from: data) else {
                print(error ?? "generic error")
                completion(nil)
                return
            }
            
            print("Categories content: \(categories)")
            completion(categories)
        }
        
        task.resume()
    }
    
    static func fetchVideos(forCategory category: Category, completion: @escaping ([Video]?) -> ()) {
        guard let categoryUUID = category.id else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: Constants.Url.localhost.appendingPathComponent("category/uuid=\(categoryUUID.uuidString)/media"))
        request.httpMethod = "GET"
        request.setValue(AccountManager.authentication, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataUnwrapped = data, error == nil, let videos = try? JSONDecoder().decode([Video].self, from: dataUnwrapped) else {
                completion(nil)
                return
            }
            
            print("Videos content: \(videos)")
            completion(videos)
        }
        
        task.resume()
    }
    
    static func upload(videoURL: URL, toCategory category: Category, completion: @escaping (Bool) -> ()) {
        do {
            guard let uploadLink = ServerRequestManager.Constants.Url.uploadVideoIn(category: category) else {
                completion(false)
                return
            }
            
            let videoData = try Data(contentsOf: videoURL)
            let headers: HTTPHeaders = ["Authorization" : AccountManager.authentication, "Content-type": "multipart/form-data"]
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(videoData, withName: "filename", fileName: videoURL.lastPathComponent, mimeType: "quicktime/mov")
            }, to: uploadLink, method: .post, headers: headers)
                .response { response in
                    print(response)
            }
            
            completion(true)
        } catch {
            completion(false)
        }
    }
}
