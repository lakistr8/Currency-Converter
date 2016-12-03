//
//  ExchangeManager.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/3/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import Foundation


struct Currency {
    let code: String
    var rate: Double?
    var lastUpdated: Date?
}


final class ExchangeManager {
    
    static let shared = ExchangeManager()
    private init() {
        
    }

}
