//
//  ActionViewController.swift
//  MobileLabTableKit
//
//  Created by Nien Lam on 4/13/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit

// Note: Protocol delegates for handling image picker.
class ActionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var selectedImageURL: URL?
    
    // Callback method to be defined in parent view controller.
    var didSaveElement: ((_ element: Element) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func handleSaveButton(_ sender: UIButton) {
        
        // Get current date and time.
        let currentDate = Date()

        // Setup formatter.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm:ss"

        // Set date string with formatted date and time.
        let dateString = dateFormatter.string(from: currentDate)
        
        // Set and pass back data element.
        let element = Element(date: dateString,
                              message: messageTextField.text ?? "",
                              imageURL: self.selectedImageURL)
        didSaveElement?(element)
        
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func handleGetImageButton(_ sender: UIButton) {
        // Create and present image picker using photo library.
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate   = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Get image and set to image view.
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.selectedImageView.image = image

        // Save selected image URL.
        self.selectedImageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        
        // Dismiss image picker after making selection.
        picker.dismiss(animated: true, completion: nil)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismisses keyboard when done is pressed.
        view.endEditing(true)
        return false
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
