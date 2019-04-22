//
//  ServerResponse.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 22.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation

struct ServerResponse: Codable {
    struct Constants {
        static let userNotAuthenticated = "User not authenticated."
        static let existingUser = "a user with this username already exists"
        static let unableToConnectMessage = "Unable to connect to server."
        static let registrationSuccessful = "Registration successful!"
        static let invalidCredentials = "Invalid username or password. Please try again."
    }
    
    let error: Bool
    let reason: String
    
    private enum CodingKeys: String, CodingKey {
        case error = "serverresponse_error"
        case reason = "serverresponse_reason"
    }
    
    static func errorReason(rawJSON: String) -> String? {
        let data = rawJSON.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                if let reason = jsonArray["reason"] as? String {
                    return reason
                }
            }
        } catch {
            return "An unknown error has occured"
        }
        return nil
    }
}
