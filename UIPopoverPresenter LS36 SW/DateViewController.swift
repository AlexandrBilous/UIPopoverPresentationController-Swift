//
//  DateViewController.swift
//  UIPopoverPresenter LS36 SW
//
//  Created by Marentilo on 15.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    var pickedDate = Date()
    weak var delegate : DateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView () {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.maxX, height: 300)
        
        navigationItem.title =  "Choose a date"
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonForDatePressed(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        datePicker.date = pickedDate
        datePicker.addTarget(self, action: #selector(dateValueDidChange(sender:)), for: .valueChanged)
                view.addSubview(datePicker)
    }
    
    @objc func dateValueDidChange(sender: UIDatePicker) {
        delegate?.dateValueDidChange(sender: sender)
    }
    
    @objc func saveButtonForDatePressed(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

protocol DateViewControllerDelegate : class{
    func dateValueDidChange (sender : UIDatePicker);
}
