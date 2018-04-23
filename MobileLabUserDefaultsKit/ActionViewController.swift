//
//  ActionViewController.swift
//  MobileLabTableKit
//
//  Created by Nien Lam on 4/13/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    
    // Callback method to be defined in parent view controller.
    var didSaveElement: ((_ element: Element) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func handleSaveButton(_ sender: UIButton) {
        
        // Get current time and date.
        let dateString = NSDate().description
        
        // Pass back data.
        let element = Element(date: dateString, message: messageTextField.text!)
        didSaveElement?(element)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismisses keyboard when done is pressed.
        view.endEditing(true)
        return false
    }
}
