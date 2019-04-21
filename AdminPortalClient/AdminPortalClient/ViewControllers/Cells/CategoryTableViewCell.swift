//
//  CategoryTableViewCell.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 21.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
