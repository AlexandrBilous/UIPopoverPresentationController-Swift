//
//  EducationViewController.swift
//  UIPopoverPresenter LS36 SW
//
//  Created by Marentilo on 15.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol EducationViewControllerDelegate : class {
    func didSelectRow (row: Int, inComponent component: Int, withTitle title: String)
}

class EducationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    required init?(coder: NSCoder) {
        choosenRow = 0
        super.init(coder: coder)
    }
    
    init(row: Int) {
        choosenRow = row
        
        super.init(nibName: nil, bundle: nil)
    }
    
    let choosenRow : Int
    var arrayOfLevels = ["Pre-school", "Elementary school", "Secondary", "College", "University - bachelor", "University - master", "University - doctor"]
    
    weak var educationDelegate: EducationViewControllerDelegate?
    var picker : UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView () {
        navigationItem.title =  "Choose an education"
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonForEducationPressed(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let educationPicker = UIPickerView()
        educationPicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.maxX, height: 300)
        educationPicker.dataSource = self
        educationPicker.delegate = self
        educationPicker.selectRow(choosenRow, inComponent: 0, animated: true)

        
        view.addSubview(educationPicker)
    }
    


    
    // MARK: - UIPickerDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfLevels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfLevels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        educationDelegate?.didSelectRow(row: row, inComponent: component, withTitle: arrayOfLevels[row])
    }
    
    @objc func saveButtonForEducationPressed(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
