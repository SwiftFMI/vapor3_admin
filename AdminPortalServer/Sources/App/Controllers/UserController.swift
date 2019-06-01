//
//  UserController.swift
//  AdminPortalServerPackageDescription
//
//  Created by Dimitar Stoyanov on 18.04.19.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite
import Crypto

final class UserController: RouteCollection {
    struct Constants {
        static let existingUserError = "A user with this username already exists"
    }
    func boot(router: Router) throws {
        let group = router.grouped("api", "users")
        group.post(User.self, at: "register", use: registerUserHandler)
    }
    
    static func registerAdminUser() {
        let url = URL(string: "http://localhost:8080/api/users/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "permissions=admin&password=admin&username=admin".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error", error ?? "Unknown error")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            if responseString == "" {
                print("Administrator account created")
            }
        }
        
        task.resume()
    }
    
    func authPermissionRequest(_ request: Request) throws-> Future<String> {
        let name = try request.parameters.next(String.self)
        return User.query(on: request).filter(\.username == name).first().unwrap(or: Abort(.notFound)).map { (user) -> (String) in
            return user.permissions
        }
    }
}

//MARK: Helper
private extension UserController {
    
    func registerUserHandler(_ request: Request, newUser: User) throws -> Future<HTTPResponseStatus> {
        return User.query(on: request).filter(\.username == newUser.username).first().flatMap { existingUser in
            guard existingUser == nil else {
                throw Abort(.badRequest, reason: "A user with this username already exists.")
            }
            
            let digest = try request.make(BCryptDigest.self)
            let hashedPassword = try digest.hash(newUser.password)
            let persistedUser = User(id: nil, username: newUser.username, password: hashedPassword, permissions: newUser.permissions)
            
            return persistedUser.save(on: request).transform(to: .created)
        }
    }
}
