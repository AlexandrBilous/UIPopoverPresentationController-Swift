//
//  CountryViewController.swift
//  UIPopoverPresenter LS36 SW
//
//  Created by Marentilo on 16.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol CountryViewCountrollerDelegate : class {
    func selectRow (didSelectRowAt indexPath: IndexPath, withName name: String, isFullScreen: Bool)
}

class CountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    init(isFullScreen: Bool) {
        self.isFullScreen = isFullScreen
            
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.isFullScreen = false
        super.init(coder: coder)
    }
   
    weak var countryDelegate : CountryViewCountrollerDelegate?
    var selectedRow = IndexPath(row: 0, section: 0)
    var isFullScreen : Bool

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView () {
        navigationItem.title = "Country"
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonForCountryPressed(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        sortCountries(allCountries: countriesList, withFilter: "")
        
        let sc = UISearchController()
        sc.searchBar.delegate = self
        navigationItem.searchController = sc
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        view.addSubview(tableView)
    }
    
    func sortCountries (allCountries: [String], withFilter filter : String) {
        var namesSet = Set<String>()
        sections = [String]()
        groupedCountries = [String : [String]]()
        
        for item in countriesList {
            let newName = "\(item.first ?? "n")"
            
            if filter.count > 0 && !item.contains(filter) {
                continue
            }
                        
            if namesSet.contains(newName) {
                var sourceArray = groupedCountries[newName]
                sourceArray?.append(item)
                
                groupedCountries.updateValue(sourceArray!, forKey: newName)
            } else {
                namesSet.insert(newName)
                var array = [String]()
                array.append(item)
                
                sections.append(newName)
                groupedCountries[newName] = array
            }
            
        }
        
    }
    
    let countriesList = ["Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua &amp; Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia &amp; Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre &amp; Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts &amp; Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad &amp; Tobago","Tunisia","Turkey","Turkmenistan","Turks &amp; Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]
    
    var sections = [String]()
    var groupedCountries = [String : [String]]()
    
    lazy var tableView : UITableView  = {
        let windowScreen = CGRect(x: 0, y: 0, width: view.bounds.maxX - 40, height: 300)
        let fullScreen = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let table = UITableView(frame: isFullScreen ? fullScreen : windowScreen, style: .grouped)
        
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    @objc func saveButtonForCountryPressed(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedCountries[sections[section]]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
//        cell = cell == nil ? UITableViewCell(style: .subtitle, reuseIdentifier: "id") : cell
        
        let sourceName = sections[indexPath.section]
        let sourceArray = groupedCountries[sourceName]!
        
        cell.textLabel?.text = sourceArray[indexPath.row]
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }

    
    
    // MARK: UITableViewDelegate
    
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//
//        return indexPath
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sourceName = sections[indexPath.section]
        let sourceArray = groupedCountries[sourceName]!
        
        countryDelegate?.selectRow(didSelectRowAt: indexPath, withName: sourceArray[indexPath.row], isFullScreen: self.isFullScreen)
       
        tableView.cellForRow(at: selectedRow)?.accessoryType = .none
        selectedRow = indexPath
        
//        tableView.deselectRow(at: indexPath, animated: true)
//        tableView.visibleCells.forEach { (cell : UITableViewCell) in
//            if cell.textLabel?.text == sourceArray[indexPath.row] {
//                cell.accessoryType = .checkmark
//            }
//        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
    }
    
    
    // MARK: UISearchBarDelegate

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sortCountries(allCountries: countriesList, withFilter: searchBar.text ?? "nil")
        tableView.reloadData()
    }

}
