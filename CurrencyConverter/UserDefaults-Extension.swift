//
//  UserDefaults-Extension.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/3/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Key : String {
        case source
        case target
    }
    
    static var sourceCurrencyCode: String? {
        get {
            let defs = UserDefaults.standard
            return defs.string(forKey: Key.source.rawValue)
        }
        set(value) {
            let defs = UserDefaults.standard
            defs.set(value, forKey: Key.source.rawValue)
        }
    }
    
    static var targetCurrencyCode: String? {
        get {
            let defs = UserDefaults.standard
            return defs.string(forKey: Key.target.rawValue)
        }
        set(value) {
            let defs = UserDefaults.standard
            defs.set(value, forKey: Key.target.rawValue)
        }
    }
}
