import Foundation
import Vapor
import Fluent
import FluentSQLite
import Authentication

struct User: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    private(set) var username: String
    private(set) var password: String
    private(set) var permissions: String
}

extension User: PasswordAuthenticatable {
    static let usernameKey: WritableKeyPath<User, String> = \.username
    static let passwordKey: WritableKeyPath<User, String> = \.password
}
