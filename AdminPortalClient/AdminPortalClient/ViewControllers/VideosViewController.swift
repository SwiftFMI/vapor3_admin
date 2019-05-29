//
//  VideosViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 18.05.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit
import MobileCoreServices

final class VideosViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    var category: Category?
    var videos = [Video]()
    var imagePickerController = UIImagePickerController()
    
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
    
    
    // MARK: - Private
    @objc private func pullToRefreshAction(_ sender: Any?) {
        fetchVideos()
    }
    
    @IBAction private func addVideoButtonTapped(_ sender: Any) {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDatasource + UITableViewDelegate
extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
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

extension VideosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let newVideoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL, let categoryUnwrapped = category else {
            return
        }
        
        ServerRequestManager.upload(videoURL: newVideoURL, toCategory: categoryUnwrapped) { [weak self] success in
            guard success else {
                return
            }
            
            self?.pullToRefreshAction(nil)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
