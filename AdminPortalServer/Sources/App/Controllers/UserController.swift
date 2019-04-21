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

class UserController: RouteCollection {
    func boot(router: Router) throws {
        let group = router.grouped("api", "users")
        group.post(User.self, at: "register", use: registerUserHandler)
    }
}

//MARK: Helper
private extension UserController {
    
    func registerUserHandler(_ request: Request, newUser: User) throws -> Future<HTTPResponseStatus> {
        return User.query(on: request).filter(\.username == newUser.username).first().flatMap { existingUser in
            guard existingUser == nil else {
                throw Abort(.badRequest, reason: "a user with this username already exists" , identifier: nil)
            }
            
            let digest = try request.make(BCryptDigest.self)
            let hashedPassword = try digest.hash(newUser.password)
            let persistedUser = User(id: nil, username: newUser.username, password: hashedPassword, permissions: newUser.permissions)
            
            return persistedUser.save(on: request).transform(to: .created)
        }
    }
}
