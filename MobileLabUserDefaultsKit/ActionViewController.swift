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
    
    var selectedImageName: String?
    
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
                              imageName: self.selectedImageName ?? "default-image")
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

        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        // Set photoImageView to display the selected image
        self.selectedImageView.image = selectedImage
        
        // save image to FileManager
        // use hashValue of selectedImage as imageName
        saveImage(image: selectedImage, imageName: String(selectedImage.hashValue))

        // Dismiss image picker after making selection.
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(image: UIImage, imageName: String) {
        // create an instance of the FileManager
        let fileManager = FileManager.default
        
        // get the file system image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        // get the jpeg data of this image
        let data = image.jpegData(compressionQuality: 0.8)
        
        // Save the image name.
        selectedImageName = imageName
        
        // store the image in document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
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
