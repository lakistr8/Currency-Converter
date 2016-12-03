//
//  CurrencyPicker.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/3/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import UIKit

protocol CurrencyPickerControllerDelegate: class {
    
    func currencyPicker(controller: CurrencyPicker, didSelect currencyCode: String)
}

class CurrencyPicker: UITableViewController {
    
    weak var delegate: CurrencyPickerControllerDelegate? = nil
    
    var searchString : String?
    var searchController: UISearchController?
    
    var dataSource : [String] {
        let baseArr = Locale.commonISOCurrencyCodes
        //	if search string is populated, then we need to filter the result
        if let str = searchString {
            if str.characters.count > 0 {
                return baseArr.filter( {$0.localizedCaseInsensitiveContains(str)} )
            }
        }
        return baseArr
    }
    
    deinit {
        searchController?.view.removeFromSuperview()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
}

// MARK: - Table view data source

extension CurrencyPicker {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        
        let currencyCode = dataSource[indexPath.row]
        cell.configure(withCurrencyCode: currencyCode)
        
        return cell
    }
}


// MARK: - Table view delegate

extension CurrencyPicker {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currencyCode = dataSource[indexPath.row]
        
        if let _ = presentedViewController {
            dismiss(animated: false) {
                self.delegate?.currencyPicker(controller: self, didSelect: currencyCode)
            }
        } else {
            delegate?.currencyPicker(controller: self, didSelect: currencyCode)
        }
    }
}

//MARK: - SEARCH

extension CurrencyPicker: UISearchResultsUpdating {
    
    func setupSearch() {
        
        searchController = {
            let sc = UISearchController(searchResultsController: nil)
            sc.searchResultsUpdater = self
            //
            sc.hidesNavigationBarDuringPresentation = false
            sc.dimsBackgroundDuringPresentation = false
            
            //
            sc.searchBar.searchBarStyle = UISearchBarStyle.prominent
            self.navigationItem.titleView = sc.searchBar
            sc.searchBar.sizeToFit()
            
            return sc
        }()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchString = searchController.searchBar.text
        self.tableView.reloadData()
    }
}
