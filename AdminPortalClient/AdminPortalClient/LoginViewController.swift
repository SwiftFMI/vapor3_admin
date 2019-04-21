//
//  LoginViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 13.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let loginString = "\(usernameTextField.text!):\(passwordTextField.text!)"
        
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        print(base64LoginString)
        let url = URL(string: "http://localhost:8080/permissions/\(usernameTextField.text!)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error", error ?? "Unknown error")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("Response: \(responseString ?? "Unknown response")")
        }
        
        task.resume()
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        let url = URL(string: "http://localhost:8080/api/users/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["username": usernameTextField.text!, "password": passwordTextField.text!, "permissions": "viewer"]
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error", error ?? "Unknown error")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("Response: \(responseString ?? "Unknown response")")
        }
        
        task.resume()
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
