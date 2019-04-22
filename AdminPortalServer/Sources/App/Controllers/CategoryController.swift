//
//  CategoryController.swift
//  App
//
//  Created by Dimitar Stoyanov on 22.04.19.
//

import Foundation
import Vapor
import HTTP

final class CategoryController {
    
    var categories = [Category]()
    
    /// Saves a decoded Category
    func create(_ req: Request) throws -> Future<Category> {
        print("creating category")
        return try req.content.decode(Category.self).flatMap { category in
            return category.save(on: req).map({ (category) -> Category in
                print(category)
                return category
            })
        }
    }
    
    /// Returns all Categories
    func request(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
}
