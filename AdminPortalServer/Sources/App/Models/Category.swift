//
//  Category.swift
//  AdminPortalServerPackageDescription
//
//  Created by Dimitar Stoyanov on 22.04.19.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite
import Authentication

struct Category: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    
    var title: String
    var description: String
    var image: Data
}
