//
//  NewCategoryViewController.swift
//  AdminPortalClient
//
//  Created by Dimitar Stoyanov on 22.04.19.
//  Copyright © 2019 Dimitar Stoyanov. All rights reserved.
//

import Foundation
import UIKit

final class NewCategoryViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func pickImageTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryPicker = UIImagePickerController()
            libraryPicker.delegate = self
            libraryPicker.sourceType = .photoLibrary
            libraryPicker.allowsEditing = true
            self.present(libraryPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func createCategoryTapped(_ sender: Any) {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0), let textFieldText = titleTextField.text, let descriptionFieldText = descriptionTextField.text else {
            return
        }
        
        let category = Category(id: nil, title: textFieldText , description: descriptionFieldText, image: imageData, videos: [])
        let categoryData = try? JSONEncoder().encode(category)
        ServerRequestManager.createCategory(categoryData) { [weak self] success in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate + UINavigationControllerDelegate
extension NewCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}
