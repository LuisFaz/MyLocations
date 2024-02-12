//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Luis Faz on 2/11/24.
//

import UIKit
import CoreLocation

// DateFormatter used to format dates
private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .short
  return formatter
}()

class LocationDetailsViewController: UITableViewController {
  
  // MARK: - Outlets
  
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var categoryLabel: UILabel!
  @IBOutlet var latitudeLabel: UILabel!
  @IBOutlet var longitudeLabel: UILabel!
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!

  // MARK: - Properties
  
  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var placemark: CLPlacemark?
  var categoryName = "No Category"

  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Initialize UI elements and data
    descriptionTextView.text = ""
    categoryLabel.text = categoryName

    latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
    longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
    
    // Set address label based on placemark information
    if let placemark = placemark {
      addressLabel.text = string(from: placemark)
    } else {
      addressLabel.text = "No Address Found"
    }

    // Format and set date label
    dateLabel.text = format(date: Date())

    // Hide keyboard when tapping outside of text view
    let gestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(hideKeyboard))
    gestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(gestureRecognizer)
  }

  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Prepare for navigation to CategoryPickerViewController
    if segue.identifier == "PickCategory" {
      let controller = segue.destination as! CategoryPickerViewController
      controller.selectedCategoryName = categoryName
    }
  }

  // MARK: - Actions
  
  @IBAction func done() {
    // Display a HUD (Head-Up Display) indicating successful tagging
    guard let mainView = navigationController?.parent?.view else { return }
    let hudView = HudView.hud(inView: mainView, animated: true)
    hudView.text = "Tagged"
    afterDelay(0.6) {
      hudView.hide()
      self.navigationController?.popViewController(animated: true)
    }
  }

  @IBAction func cancel() {
    // Cancel the operation and navigate back
    navigationController?.popViewController(animated: true)
  }

  @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
    // Handle category selection from CategoryPickerViewController
    let controller = segue.source as! CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
  }

  // MARK: - Helper Methods
  
  func string(from placemark: CLPlacemark) -> String {
    // Create a formatted string from placemark components
    var text = ""
    if let tmp = placemark.subThoroughfare {
      text += tmp + " "
    }
    if let tmp = placemark.thoroughfare {
      text += tmp + ", "
    }
    if let tmp = placemark.locality {
      text += tmp + ", "
    }
    if let tmp = placemark.administrativeArea {
      text += tmp + " "
    }
    if let tmp = placemark.postalCode {
      text += tmp + ", "
    }
    if let tmp = placemark.country {
      text += tmp
    }
    return text
  }

  func format(date: Date) -> String {
    // Format a date using the dateFormatter
    return dateFormatter.string(from: date)
  }

  @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
    // Hide the keyboard when tapping outside of the text view
    let point = gestureRecognizer.location(in: tableView)
    let indexPath = tableView.indexPathForRow(at: point)

    if indexPath != nil && indexPath!.section == 0 &&
        indexPath!.row == 0 {
      return
    }
    descriptionTextView.resignFirstResponder()
  }

  // MARK: - Table View Delegates
  
  override func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
    // Enable selection only for specific rows
    if indexPath.section == 0 || indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    // Handle selection of a row in the table view
    if indexPath.section == 0 && indexPath.row == 0 {
      descriptionTextView.becomeFirstResponder()
    }
  }
}
