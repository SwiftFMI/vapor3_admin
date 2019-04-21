//
//  LoginViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 13.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak private var usernameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayMessage()
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
        
        guard let permissions =  AccountManager.shared.user?.permissions else {
            let responseError = ServerResponse.errorReason(rawJSON: responseUnwrapped)
            if responseError == ServerResponse.Constants.userNotAuthenticated {
                displayMessage(message: "Invalid username or password. Please try again.", color: .red)
            }
            return
        }
        
        displayMessage(message: "Logged in as \(permissions)", color: .green)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showCategories", sender: nil)
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
