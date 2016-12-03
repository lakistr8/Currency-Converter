//
//  UserDefaults-Extension.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/3/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import Foundation

enum UserDefaultsKey : String {
    case sourceCurrencyCode
    case targetCurrencyCode
}

extension UserDefaults {
    
    static var sourceCurrencyCode: String? {
        get {
            let defs = UserDefaults.standard
            return defs.string(forKey: UserDefaultsKey.sourceCurrencyCode.rawValue)
        }
        set(value) {
            let defs = UserDefaults.standard
            defs.set(value, forKey: UserDefaultsKey.sourceCurrencyCode.rawValue)
        }
    }
    
    static var targetCurrencyCode: String? {
        get {
            let defs = UserDefaults.standard
            return defs.string(forKey: UserDefaultsKey.targetCurrencyCode.rawValue)
        }
        set(value) {
            let defs = UserDefaults.standard
            defs.set(value, forKey: UserDefaultsKey.targetCurrencyCode.rawValue)
        }
    }
}
