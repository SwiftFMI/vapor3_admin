//
//  File.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 2.06.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation

class File: Codable {
    /// Name of the file, including extension.
    public var filename: String
    
    /// The file's data.
    public var data: Data
    
    init(data: Data, filename: String) {
        self.data = data
        self.filename = filename
    }
}
