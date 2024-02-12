//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Luis Faz on 2/11/24.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
  
  // MARK: - Properties
  
  var selectedCategoryName = "" // Currently selected category name
  var selectedIndexPath = IndexPath() // IndexPath of the selected category in the table view
  
  // Predefined categories for selection
  let categories = [
    "No Category",
    "Apple Store",
    "Bar",
    "Bookstore",
    "Club",
    "Grocery Store",
    "Historic Building",
    "House",
    "Icecream Vendor",
    "Landmark",
    "Park"
  ]

  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Find the index of the selected category in the predefined categories
    for i in 0..<categories.count {
      if categories[i] == selectedCategoryName {
        selectedIndexPath = IndexPath(row: i, section: 0)
        break
      }
    }
  }

  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Prepare for navigation to indicate the picked category
    if segue.identifier == "PickedCategory" {
      let cell = sender as! UITableViewCell
      if let indexPath = tableView.indexPath(for: cell) {
        selectedCategoryName = categories[indexPath.row]
      }
    }
  }
  
  // MARK: - Table View Delegates
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of categories for the table view
    return categories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Configure and return cells for each category in the table view
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    let categoryName = categories[indexPath.row]
    cell.textLabel!.text = categoryName

    // Set checkmark accessory for the selected category
    if categoryName == selectedCategoryName {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Handle selection of a category in the table view
    
    if indexPath.row != selectedIndexPath.row {
      // Update checkmark accessory for the newly selected category
      if let newCell = tableView.cellForRow(at: indexPath) {
        newCell.accessoryType = .checkmark
      }
      
      // Remove checkmark from the previously selected category
      if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
        oldCell.accessoryType = .none
      }
      
      // Update the selectedIndexPath to the newly selected category
      selectedIndexPath = indexPath
    }
  }
}
