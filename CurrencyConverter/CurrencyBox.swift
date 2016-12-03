//
//  CurrencyBox.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/2/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import UIKit

protocol CurrencyBoxDelegate: class {
    
    func currencyBoxInitiatedChange(_ currencyBox: CurrencyBox)
}

class CurrencyBox: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    weak var delegate: CurrencyBoxDelegate?
    
    //	using computed property for both get/set
    var amountText: String? {
        get {
            return textField.text
        }
        set(str) {
            textField.text = str
        }
    }
    
    func configure(withCurrencyCode currencyCode: String) {
        
        //	update label
        currencyCodeLabel.text = currencyCode
        
        //	update flag image, using Locale framework
        guard let countryCode = Locale.countryCode(forCurrencyCode: currencyCode) else {
            flagImageView.image = nil
            return
        }
        
        flagImageView.image = UIImage(named: countryCode.lowercased())
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.currencyBoxInitiatedChange(self)
    }
}
