//
//  VideoTableViewCell.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 14.05.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation
import UIKit

final class VideoTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func configureWith(video: Video) {
        titleLabel.text = video.title
        descriptionLabel.text = video.description
    }
}
