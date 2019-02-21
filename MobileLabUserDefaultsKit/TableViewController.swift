//
//  TableViewController.swift
//  MobileLabTableKit
//
//  Created by Nien Lam on 4/13/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TableViewCell"

private let elementArrayKey = "ELEMENT_ARRAY_KEY"


// Data element for table row.
// Note the "Codable" protocol
struct Element: Codable {
    let date: String
    let message: String
    let imageURL: URL?
}


class TableViewController: UITableViewController {

    // Data array for table table.
    var elementArray = [Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get Data from user defaults and set data array.
        if let data = UserDefaults.standard.value(forKey: elementArrayKey) as? Data {

            let elementArray = try? PropertyListDecoder().decode(Array<Element>.self, from: data)
            
            self.elementArray = elementArray!

            self.tableView.reloadData()
        }
    }


    @IBAction func handleAddButton(_ sender: UIBarButtonItem) {
        
        // Instantiate View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ActionViewController") as? ActionViewController else {
            print("Error instantiating ActionViewController" )
            return
        }
        
        // Define callback method.
        vc.didSaveElement = { [weak self] element in
            
            self?.elementArray.append(element)
            
            // Resave element array into User defaults.
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self?.elementArray), forKey: elementArrayKey)
            
            self?.tableView.reloadData()
        }
        
        // Present view controller.
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the row data count.
        return elementArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get custom cell object.
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        
        let element = elementArray[indexPath.row]
        
        cell.dateLabel.text = element.date
        cell.messageLabel.text = element.message

        // Unwrap element.imageURL optional.
        if let imageURL = element.imageURL {

            // Need to wrap try block for getting data element.
            do {
                // Convert imageURL to data.
                let data = try Data(contentsOf: imageURL)

                // Convert data into UIImage.
                let image = UIImage(data: data)

                // Set cell imageView with image.
                cell.mainImageView.image = image
            } catch {
                print("Error loading imageURL", error)
            }
        }
        
        return cell
    }
}
