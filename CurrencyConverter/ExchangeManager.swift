//
//  ExchangeManager.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/3/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import Foundation


enum ExchangeError: Error {
    
    case missingRate(String)
    case invalidResponse
    case networkError(NSError?)
}

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
    
    fileprivate let baseCurrency = "USD"
    fileprivate var rates = [String: Currency]()
    
    func populateRates() {
        for cc in Locale.commonISOCurrencyCodes {
            rates[cc] = Currency(code: cc)
        }
    }
    
    func rate(for targetCC: String,
              versus sourceCC: String,
              completionHandler: @escaping (Double?, ExchangeError?) -> Void ) {
        
        do {
            let rate = try convert(from: sourceCC, to: targetCC)
            completionHandler(rate, nil)
            return
        } catch {
            
        }
        
        fetchCurrencyRate(for: sourceCC, completionHandler: completionHandler)
    }
    
    private let baseURL = "https://download.finance.yahoo.com/d/quotes.csv?f=sb&s="
    
    private func singleConversionURL(_ sourceCurrency: String,
                                     targetCurrency: String  ) -> URL {
        
        var s = baseURL;
    
        var niz : [String] = []
        if sourceCurrency != baseCurrency {
            niz.append(baseCurrency + sourceCurrency + "=X")
        }
        if targetCurrency != baseCurrency {
            niz.append(baseCurrency + targetCurrency + "=X")
        }
        
        s += niz.joined(separator: ",")
        
        return URL(string: s)!
    }
}


extension ExchangeManager {
    
    fileprivate func convert(from sourceCC: String,
                             to targetCC: String) throws -> Double? {
        
        let sourceCurrency = rates[sourceCC]
        guard let sourceRate = sourceCurrency?.rate else {
            throw ExchangeError.missingRate(sourceCC)
        }
        let targetCurrency = rates[targetCC]
        guard let targetRate = targetCurrency?.rate else {
            throw ExchangeError.missingRate(targetCC)
        }
        
        return targetRate / sourceRate
    }
    
    fileprivate func fetchCurrencyRate(for currency: String,
                                       completionHandler: @escaping (Double?, ExchangeError?) -> Void ) {
        
        //	create URL to call
        let currencies = "\(baseCurrency)\(currency)=X"
        guard let url = URL(string: "https://download.finance.yahoo.com/d/quotes.csv?f=sb&s="+currencies) else { return }
        
        //	using shared URL session, make a data task..
        let task = URLSession.shared.dataTask(with: url) {
            data, urlResponse, error in
            
            //	process the returned stuff, now
            
            
            
            
            
            let rate = 0.0
            let error: ExchangeError? = nil
            completionHandler(rate, error)
            
        }
        //	and execute it
        task.resume()
        
    }
}
