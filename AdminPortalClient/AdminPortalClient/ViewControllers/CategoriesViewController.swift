//
//  CategoriesViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

final class CategoriesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addCategoryButton: UIButton!
    @IBOutlet private weak var modifyCategoriesButton: UIButton!
    @IBOutlet private weak var moderateUsersButton: UIButton!
    
    private let refreshControl = UIRefreshControl()
    private var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Logged in as '\(AccountManager.shared.user?.username ?? "user")'"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        refreshControl.addTarget(nil, action: #selector(pullToRefreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        showPermittedActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCategories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let videosViewController = segue.destination as? VideosViewController, let senderUnwrapped = sender as? (Category, [Video]) else {
            return
        }
        
        videosViewController.navigationItem.title = senderUnwrapped.0.title
        videosViewController.category = senderUnwrapped.0
        videosViewController.videos = senderUnwrapped.1
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
    
    @objc private func pullToRefreshAction(_ sender: Any) {
        fetchCategories()
    }
    
    private func showPermittedActions() {
        guard let userPermissions = AccountManager.shared.user?.permissions else {
            return
        }
        
        addCategoryButton.isHidden = !userPermissions.canAddCategories
        modifyCategoriesButton.isHidden = !userPermissions.canModifyCategories
        moderateUsersButton.isHidden = !userPermissions.canModerateUsers
    }
    
    // MARK: - IBActions
    @IBAction func addCategoryButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showNewCategory", sender: nil)
    }
    
    @IBAction func modifyCategoriesButtonTapped(_ sender: Any) {
        // TODO
    }
    
    @IBAction func moderateUsers(_ sender: Any) {
        
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
        
        cell.configureWith(category: categories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < categories.count else {
            return
        }
        
        ServerRequestManager.fetchVideos(forCategory: categories[indexPath.row]) { [weak self] (videos) in
            guard let videosUnwrapped = videos else {
                return
            }
            
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: "showVideos", sender: (self?.categories[indexPath.row], videosUnwrapped))
            }
        }
    }
}

