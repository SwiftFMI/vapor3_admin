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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        ServerRequestManager.fetchCategories()
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = AccountManager.shared.categories else {
            return 0
        }
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categories = AccountManager.shared.categories else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.categoryImageView.image = UIImage(data: categories[indexPath.row].image)
        cell.titleLabel.text = categories[indexPath.row].title
        cell.descriptionLabel.text = categories[indexPath.row].description
        
        return cell
    }
}
