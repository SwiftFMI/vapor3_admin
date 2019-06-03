//
//  Video.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 13.05.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation

/// Represents a single Video
struct Video: Codable {
    var id: UUID?
    
    /// Title of the Video.
    var title: String
    
    /// Short Video description.
    var description: String
    
    /// The URL of the Video on the server.
    var url: URL
}
