//
//  VideosViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 18.05.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

final class VideosViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var category: Category?
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(nil, action: #selector(pullToRefreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchVideos()
    }
    
    // MARK: - Private
    private func fetchVideos() {
        guard let categoryUnwrapped = category else {
            return
        }
        
        ServerRequestManager.fetchVideos(forCategory: categoryUnwrapped) { [weak self] (videos) in
            guard let videosUnwrapped = videos else {
                self?.refreshControl.endRefreshing()
                return
            }
            
            self?.videos = videosUnwrapped
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func pullToRefreshAction(_ sender: Any) {
        fetchVideos()
    }
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureWith(video: videos[indexPath.row])
        
        return cell
    }
    
    
}
