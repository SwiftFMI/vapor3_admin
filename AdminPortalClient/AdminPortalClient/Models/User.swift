//
//  User.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation

struct User {
    enum Permissions: StringLiteralType {
        case admin
        case uploader
        case viewer
        
        var canViewContent: Bool {
            return true
        }
        
        var canAddCategories: Bool {
            switch self {
            case .admin: return true
            case .uploader: return true
            case .viewer: return false
            }
        }
        
        var canModifyCategories: Bool {
            switch self {
            case .admin: return true
            case .uploader: return true
            case .viewer: return false
            }
        }
        
        var canDeleteCategories: Bool {
            switch self {
            case .admin: return true
            case .uploader: return true
            case .viewer: return false
            }
        }
        
        var canUploadVideos: Bool {
            switch self {
            case .admin: return true
            case .uploader: return true
            case .viewer: return false
            }
        }
        
        var canModifyVideos: Bool {
            switch self {
            case .admin: return true
            case .uploader: return true
            case .viewer: return false
            }
        }
        
        var canDeleteVideos: Bool {
            switch self {
            case .admin: return true
            case .uploader: return true
            case .viewer: return false
            }
        }
        
        var canChangeUserPermissions: Bool {
            switch self {
            case .admin: return true
            case .uploader: return false
            case .viewer: return false
            }
        }
        
        var canModerateUsers: Bool {
            switch self {
            case .admin: return true
            case .uploader: return true
            case .viewer: return false
            }
        }
    }
    
    var username: String
    var password: String
    var permissions: Permissions?
}
