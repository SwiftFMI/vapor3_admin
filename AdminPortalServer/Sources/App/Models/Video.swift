//
//  Video.swift
//  AdminPortalServerPackageDescription
//
//  Created by Dimitar Stoyanov on 11.05.19.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite
import Authentication

struct Video: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    
    var title: String
    var description: String
    var url: URL
}
