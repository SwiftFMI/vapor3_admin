import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    
    /// Creates the Administrator user
    init() {
        registerAdminUser()
    }
    
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }
    
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }
    
    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
            }.transform(to: .ok)
    }
    
    private func registerAdminUser() {
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
}
