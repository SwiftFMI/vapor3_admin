//
//  CategoriesViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

final class CategoriesViewController: UIViewController {

    @IBOutlet private weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = AccountManager.shared.user {
            let attributedString = NSMutableAttributedString(string: "Welcome \(user.username)", attributes: nil)
            let welcomeCount = "Welcome ".count
            let usernameRange = NSRange(location: welcomeCount, length: attributedString.string.count - welcomeCount)
            attributedString.setAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], range: usernameRange)
            welcomeLabel.attributedText = attributedString
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}
