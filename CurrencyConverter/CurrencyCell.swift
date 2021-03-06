//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/3/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        currencyLabel.text = nil
        iconView.image = nil
        currencyLabel.textColor = .white
    }
    
    func configure(withCurrencyCode currencyCode: String) {
        
        //	update label
        currencyLabel.text = currencyCode
        
        //	update flag image, using Locale framework
        guard let countryCode = Locale.countryCode(forCurrencyCode: currencyCode) else {
            iconView.image = #imageLiteral(resourceName: "empty")
            return
        }
        
        iconView.image = UIImage(named: countryCode.lowercased())
    }
}
