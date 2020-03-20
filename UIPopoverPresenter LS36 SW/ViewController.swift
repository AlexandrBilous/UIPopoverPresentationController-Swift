//
//  ViewController.swift
//  UIPopoverPresenter LS36 SW
//
//  Created by Marentilo on 15.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UITextFieldDelegate, DateViewControllerDelegate, EducationViewControllerDelegate, CountryViewCountrollerDelegate {
    
    let rows = ["FirstName", "LastName", "Sex", "Date of Birth", "Education", "Country", "Fullscreen country"]
    var textFields = [UITextField]()
    var selectedDate = Date()
    var selectedEducation = 0
    var selectedCountry : IndexPath!
    
    let sexController : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Male", "Female"])
        sc.frame = CGRect(x: 200, y: 5, width: 200, height: 40)
        return sc
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    func setupNavigation () {
        navigationItem.title = "Registration form"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(infoButtonPressed(sender:)))
        
        for (index, item) in rows.enumerated() {
            let textField = UITextField(frame: CGRect(x: 200, y: 5, width: 200, height: 40))
            textField.placeholder = "Enter \(item)"
            textField.borderStyle = .roundedRect
            textField.delegate = self
            textField.tag = index
            textFields.append(textField)
        }
    }
    
    func showCountryPicker () {
        let countryPicker = CountryViewController(isFullScreen: false)
        countryPicker.countryDelegate = self
        showController(vc: countryPicker, inPopoverFromSender: textFields[5])
    }
    
    func showFullScreenCountryPicker() {
        let countryPicker = CountryViewController(isFullScreen: true)
        countryPicker.countryDelegate = self
        
        print(countryPicker.children.count)
        
        
        countryPicker.modalPresentationStyle = .popover
        let navController = UINavigationController(rootViewController: countryPicker)
        navController.preferredContentSize = CGSize(width: self.view.bounds.maxX, height: 300)
        
        let popover = navController.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = textFields[6]
        popover?.sourceRect = CGRect(x: textFields[6].frame.width / 2, y: textFields[6].frame.height, width: 0, height: 0)
        present(navController, animated: true, completion: nil)
    }
    
    func showDatePicker () {
        let dateView = DateViewController()
        dateView.pickedDate = selectedDate
        dateView.delegate = self
        showController(vc: dateView, inPopoverFromSender: textFields[3])
    }
    
    func showEducationPicker () {
        let education = EducationViewController(row: selectedEducation)
        education.educationDelegate = self
        showController(vc: education, inPopoverFromSender: textFields[4])
//        education.educationDelegate = self
//
//
//        let navController = UINavigationController(rootViewController: education)
//        navController.preferredContentSize = CGSize(width: self.view.bounds.maxX, height: 300)
//        navController.modalPresentationStyle = .popover
//
//        let popover = navController.popoverPresentationController
//        popover?.delegate = self
//        popover?.sourceView = textFields[4]
//        popover?.sourceRect = CGRect(x: textFields[4].frame.width / 2, y: textFields[4].frame.height, width: 0, height: 0)
//
//        present(navController, animated: true, completion: nil)
    }
    
    
    // MARK: Actions
    
    @objc func infoButtonPressed (sender: UIBarButtonItem) {
        let info = InfoViewController()
//        info.preferredContentSize = CGSize(width: 200, height: 200)
        showController(vc: info, inPopoverFromSender: sender)
//        info.modalPresentationStyle = .popover
//
//        let popover = info.popoverPresentationController
//        popover?.barButtonItem = self.navigationItem.rightBarButtonItem
//        popover?.delegate = self
//        present(info, animated: true, completion: nil)
//      showController(vc: info, inPopoverFromSender: sender)

    }
    
    
    func showController (vc: UIViewController, inPopoverFromSender sender: Any) {
        
        let nav = UINavigationController(rootViewController: vc)
        nav.preferredContentSize = CGSize(width: self.view.bounds.maxX, height: 300)
        nav.modalPresentationStyle = .popover
        
        let popover = nav.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .any
        if sender is UIBarButtonItem {
            popover?.barButtonItem = sender as! UIBarButtonItem
        } else if sender is UITextField {
            let field = sender as! UITextField
            popover?.sourceRect = CGRect(x: field.frame.width / 2, y: field.frame.height, width: 0, height: 0)
            popover?.sourceView = field
        }
        
        present(nav, animated: true, completion: nil)
        
    }
    
    // MARK: EducationViewControllerDelegate
    
    func didSelectRow (row: Int, inComponent component: Int, withTitle title: String) {
        textFields[4].text = title
        selectedEducation = row
        
    }
    
    // MARK: CountryViewCountrollerDelegate
    
    func selectRow (didSelectRowAt indexPath: IndexPath, withName name: String, isFullScreen: Bool) {
        if isFullScreen {
           textFields[6].text = name
        } else {
            textFields[5].text = name
        }
        selectedCountry = indexPath
    }
    
    // MARK: DateViewControllerDelegate
    
    func dateValueDidChange(sender: UIDatePicker) {
        selectedDate = sender.date
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "dd-MMM-YYYY"
        textFields[3].text = formatter.string(from: selectedDate)
    }
    
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 3:
            showDatePicker()
        case 4:
            showEducationPicker()
        case 5:
            showCountryPicker()
        case 6:
            showFullScreenCountryPicker()
        default:
            break
        }
        
        return textField.tag < 3
    }
    
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "id")
        cell = cell == nil ? UITableViewCell(style: .default, reuseIdentifier: "id") : cell
        
        cell?.textLabel?.text = rows[indexPath.row]
        
        cell?.contentView.addSubview(indexPath.row == 2 ? sexController : textFields[indexPath.row])
        
        return cell!
    }

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    

}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
         return .none
     }

     func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
         return .none
     }
    
}
