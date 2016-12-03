//
//  CurrencyBox.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/2/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import UIKit

class CurrencyBox: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    func configure(withCurrencyCode currencyCode: String) {
    
     
        currencyCodeLabel.text = currencyCode
        
     
        guard let countryCode = Locale.countryCode(forCurrencyCode: currencyCode) else {
            flagImageView.image = nil
            return
        }
        
        flagImageView.image = UIImage(named: countryCode.lowercased())
    }
    
}
