//
//  LoginViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 13.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet weak private var usernameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayMessage()
    }
    
    @IBAction private func loginTapped(_ sender: Any) {
        setButtonsInteraction(enabled: false)
        displayMessage()
        AccountManager.attemptToLogin(username: usernameTextField.text, password: passwordTextField.text, successClosure: loginCompletion, failClosure: failClosure)
    }
    
    @IBAction private func registerTapped(_ sender: Any) {
        setButtonsInteraction(enabled: false)
        displayMessage()
        AccountManager.attemptToRegister(username: usernameTextField.text, password: passwordTextField.text, successClosure: registerCompletion , failClosure: failClosure)
    }
    
    private func loginCompletion(response: String?) {
        guard let responseUnwrapped = response else {
            return
        }
        
        guard let permissions =  AccountManager.shared.user?.permissions else {
            let responseError = ServerResponse.errorReason(rawJSON: responseUnwrapped)
            if responseError == ServerResponse.Constants.userNotAuthenticated {
                setButtonsInteraction(enabled: true)
                displayMessage(message: ServerResponse.Constants.invalidCredentials, color: .red)
            }
            return
        }
        
        displayMessage(message: "Logged in as \(permissions)", color: .green)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
            self?.performSegue(withIdentifier: "showCategories", sender: nil)
            self?.setButtonsInteraction(enabled: true)
        })
    }
    
    private func registerCompletion(response: String?) {
        setButtonsInteraction(enabled: true)
        guard let responseUnwrapped = response else {
            return
        }
        
        guard response != "" else {
            displayMessage(message: ServerResponse.Constants.registrationSuccessful, color: .green)
            return
        }
        
        let responseError = ServerResponse.errorReason(rawJSON: responseUnwrapped)
        displayMessage(message: responseError, color: .red)
    }
    
    private func failClosure(error: Error?) {
        setButtonsInteraction(enabled: true)
        guard error != nil else {
            return
        }
        
        displayMessage(message: ServerResponse.Constants.unableToConnectMessage, color: .red)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showCategories" else {
            return
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = "Logout"
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setButtonsInteraction(enabled: Bool) {
        buttons.forEach { (button) in
            DispatchQueue.main.async {
                 button.isUserInteractionEnabled = enabled
            }
        }
    }
}
