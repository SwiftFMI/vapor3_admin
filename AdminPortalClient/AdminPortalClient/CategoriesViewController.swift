//
//  CategoriesViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = AccountManager.shared.user {
            DispatchQueue.main.async {
                self.welcomeLabel.text = "Welcome \(user.username)"
            }
        }
    }
}
