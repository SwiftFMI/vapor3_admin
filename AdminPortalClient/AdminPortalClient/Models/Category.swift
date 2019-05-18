//
//  CategoryModel.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation

struct Category: Codable {
    var id: UUID?
    
    var title: String
    var description: String
    var image: Data
    var videos: [Video]
}
