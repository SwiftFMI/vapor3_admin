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
    
    var videosInCategory = [(category: Category, videos: [Video])]()
    
    /// Saves a decoded Category
    func createNewCategory(_ req: Request) throws -> Future<Category> {
        print("Creating category")
        return try req.content.decode(Category.self).flatMap { [weak self] category in
            return category.save(on: req).map({ (category) -> Category in
                print(category)
                self?.videosInCategory.append((category: category, videos: []))
                return category
            })
        }
    }
    
    /// Returns all Categories
    func requestAllCategories(_ req: Request) throws -> Future<[Category]> {
        print("Requested: \(Category.query(on: req).all())")
        return Category.query(on: req).all()
    }
    
    /// Returns video UUIDs in a Category
    func requestVideosInCategory(_ req: Request) throws -> Future<[Video]> {
        let categoryId = try req.parameters.next(String.self)
        return Category.find(UUID(categoryId) ?? UUID(), on: req).map({ (category) in
            guard let categoryUnwrapped = category else {
                return []
            }
            
            return categoryUnwrapped.videos
        })
        
    }
}
