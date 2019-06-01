import Vapor
import Authentication
import Crypto

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let categoryController = CategoryController()
    let userController = UserController()
    let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
    let guardAuthMiddleware = User.guardAuthMiddleware()
    let basicAuthGroup = router.grouped([basicAuthMiddleware, guardAuthMiddleware])
    
    basicAuthGroup.get("permissions", String.parameter, use: userController.authPermissionRequest)
    basicAuthGroup.post("category", "create", use: categoryController.createNewCategory)
    basicAuthGroup.post("category", use: categoryController.requestAllCategories)
    
    basicAuthGroup.get([PathComponent.constant("category"), PathComponent.parameter("uuid"), PathComponent.constant("media")], use: categoryController.requestVideosInCategory)
    basicAuthGroup.post([PathComponent.constant("addvideo"), PathComponent.parameter("uuid")], use: categoryController.uploadVideo)
    
    try userController.boot(router: router)
    //UserController.registerAdminUser()
}

func registerUserHandler(_ request: Request, newUser: User) throws -> Future<HTTPResponseStatus> {
    return User.query(on: request).filter(\.username == newUser.username).first().flatMap { existingUser in
        guard existingUser == nil else {
            throw Abort(.badRequest, reason: UserController.Constants.existingUserError , identifier: nil)
        }
        
        let digest = try request.make(BCryptDigest.self)
        let hashedPassword = try digest.hash(newUser.password)
        let persistedUser = User(id: nil, username: newUser.username, password: hashedPassword, permissions: newUser.permissions)
        
        return persistedUser.save(on: request).transform(to: .created)
    }
}
