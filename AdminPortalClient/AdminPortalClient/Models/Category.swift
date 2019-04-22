//
//  CategoryModel.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation
import UIKit

struct Category: Codable {
    var title: String
    var description: String
    var image: Data
}
