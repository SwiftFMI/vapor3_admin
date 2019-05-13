//
//  CategoriesViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

final class CategoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Logged in as '\(AccountManager.shared.user?.username ?? "user")'"
        
        if let user = AccountManager.shared.user, let permissions = user.permissions, permissions.canAddCategories {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonItemTapped))
        }
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        refreshControl.addTarget(nil, action: #selector(pullToRefreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCategories()
    }
    
    // MARK: - Private
    private func fetchCategories() {
        ServerRequestManager.fetchCategories { [weak self] categories in
            guard let categoriesUnwrapped = categories else {
                self?.refreshControl.endRefreshing()
                return
            }
            
            self?.categories = categoriesUnwrapped
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func rightBarButtonItemTapped(_ sender: Any) {
        performSegue(withIdentifier: "showNewCategory", sender: nil)
    }
    
    @objc private func pullToRefreshAction(_ sender: Any) {
        fetchCategories()
    }
}

// MARK: - UITableViewDelegate + UITableViewDataSource
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.categoryImageView.image = UIImage(data: categories[indexPath.row].image)
        cell.titleLabel.text = categories[indexPath.row].title
        cell.descriptionLabel.text = categories[indexPath.row].description
        
        return cell
    }
}
