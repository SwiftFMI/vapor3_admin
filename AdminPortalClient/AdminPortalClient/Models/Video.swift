//
//  Video.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 13.05.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation

struct Video: Codable {
    var id: UUID?
    
    var title: String
    var description: String
    var url: URL
}
