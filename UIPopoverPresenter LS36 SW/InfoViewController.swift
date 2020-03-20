//
//  InfoViewController.swift
//  UIPopoverPresenter LS36 SW
//
//  Created by Marentilo on 15.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView () {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.text = "Info label for app 1.0"
        label.textAlignment = .center
        
        view.backgroundColor = UIColor.white
        view.addSubview(label)
    }
    
}
