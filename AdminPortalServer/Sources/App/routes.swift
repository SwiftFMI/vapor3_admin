import Vapor
import Authentication
import Crypto

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let todoController = TodoController()
    let categoryController = CategoryController()
    let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
    let guardAuthMiddleware = User.guardAuthMiddleware()
    let basicAuthGroup = router.grouped([basicAuthMiddleware, guardAuthMiddleware])
    
    router.get("todos", use: todoController.index)
    basicAuthGroup.post("todos", use: todoController.create)
    basicAuthGroup.delete("todos", use: todoController.delete)
    basicAuthGroup.get("permissions", String.parameter, use: authPermissionRequest)
    basicAuthGroup.post("category", "create", use: categoryController.create)
    basicAuthGroup.post("category", "list", use: categoryController.request)
   
    
    let userRouteController = UserController()
    try userRouteController.boot(router: router)
}

func authPermissionRequest(_ request: Request) throws-> Future<String> {
    let name = try request.parameters.next(String.self)
    return User.query(on: request).filter(\.username == name).first().unwrap(or: Abort(.notFound)).map { (user) -> (String) in
        return user.permissions
    }
}

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
