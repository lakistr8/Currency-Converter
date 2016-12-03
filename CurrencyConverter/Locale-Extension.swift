//
//  Locale-Extension.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/3/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import Foundation


extension Locale {
    
    static func countryCode(forCurrencyCode currencyCode:String) -> String? {
        
        for countryCode in NSLocale.commonISOCurrencyCodes {
            
            
            let comps = [NSLocale.Key.countryCode.rawValue: countryCode]
            
            let localeIndentyfirer = identifier(fromComponents: comps)
            
            let locale = Locale(identifier: localeIndentyfirer)
            
            guard let cc = locale.currencyCode else { continue }
            
            if cc == currencyCode {
                return currencyCode
            }
        }
        
        return nil
    }
    
}
