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
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func loginTapped(_ sender: Any) {
        displayMessage()
        AccountManager.attemptToLogin(username: usernameTextField.text, password: passwordTextField.text, successClosure: loginCompletion, failClosure: nil)
    }
    
    @IBAction private func registerTapped(_ sender: Any) {
        displayMessage()
        AccountManager.attemptToRegister(username: usernameTextField.text, password: passwordTextField.text, successClosure: registerCompletion , failClosure: nil)
    }
    
    private func loginCompletion(response: String?) {
        guard let responseUnwrapped = response else {
            return
        }
        
        if response == "viewer" {
            print("Segue viewer")
            return
        } else if response == "uploader" {
            print("Segue uploader")
            return
        } else if response == "admin" {
            print("Segue admin")
            return
        }
        
        let responseError = ServerResponse.errorReason(rawJSON: responseUnwrapped)
        if responseError == ServerResponse.Constants.userNotAuthenticated {
            displayMessage(message: "Invalid username or password. Please try again.", color: .red)
        }
    }
    
    private func registerCompletion(response: String?) {
        guard let responseUnwrapped = response else {
            return
        }
        guard response != "" else {
            displayMessage(message: "Registration successful!", color: .green)
            return
        }
        
        let responseError = ServerResponse.errorReason(rawJSON: responseUnwrapped)
        displayMessage(message: responseError, color: .red)
    }
    
    private func displayMessage(message: String? = nil, color: UIColor? = nil) {
        guard message != nil else {
            errorLabel.isHidden = true
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.text = message
            self?.errorLabel.textColor = color
            self?.errorLabel.isHidden = false
        }
    }
}
