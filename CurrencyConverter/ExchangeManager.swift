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
    fileprivate(set) var rate: Double?
    fileprivate(set) var lastUpdated: Date?
    
    init(code: String) {
        self.code = code
    }
}


final class ExchangeManager {
    
    static let shared = ExchangeManager()
    private init() {
        populateRates()
    }
    
    private let baseCurrency = "USD"
    private var rates = [String: Currency]()
    
    func populateRates() {
        for cc in Locale.commonISOCurrencyCodes {
            rates[cc] = Currency(code: cc)
        }
    }
    
    func rate(for targetCC: String, versus sourceCC: String) -> Double? {
        let source = rates[sourceCC]
        let target = rates[targetCC]
        
        guard let sourceRate = source?.rate else { return nil }
        guard let targetRate = target?.rate else { return nil }
        
        return targetRate / sourceRate
    }

}
