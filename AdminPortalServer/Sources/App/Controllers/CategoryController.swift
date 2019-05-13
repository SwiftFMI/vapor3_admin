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
    
    var videosInCategory = [(category: Category, videoUUIDs: [UUID])]()
    
    /// Saves a decoded Category
    func createNewCategory(_ req: Request) throws -> Future<Category> {
        print("Creating category")
        return try req.content.decode(Category.self).flatMap { [weak self] category in
            return category.save(on: req).map({ (category) -> Category in
                print(category)
                self?.videosInCategory.append((category: category, videoUUIDs: []))
                return category
            })
        }
    }
    
    /// Returns all Categories
    func requestAllCategories(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
//    /// Returns video UUIDs in a Category
//    func requestVideosInCategory(_ req: Request) throws -> Future<[UUID]> {
////        let id = try req.query.decode(Int.self)
////        let videoUUIDs = videosInCategory[id].videoUUIDs
//
//    }
}
