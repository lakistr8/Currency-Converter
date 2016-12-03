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
    
    var title: String {
        var str = ""
        switch self {
        case .missingRate:
            str = "Unknown rate"
        case .invalidResponse:
            str = "Invalid response"
        case .networkError(let netError):
            if let s = netError?.localizedDescription {
                str = s
            } else {
                str = "Network error"
            }
        }
        return str
    }
    
    var message: String {
        var str = ""
        switch self {
        case .missingRate(let cc):
            str = "Could not fetch rate for currency \(cc)"
        case .invalidResponse:
            str = "Our currency rate service returned unexpected response. Please try again later"
        case .networkError(let netError):
            if let s = netError?.localizedFailureReason {
                str = s
            } else {
                str = "Please try again later"
            }
        }
        return str
    }
}

struct Currency {
    let code: String
    fileprivate(set) var rate: Double?
    fileprivate(set) var lastUpdated: Date?
    
    init(code: String) {
        self.code = code
    }
}

extension Currency {
    
    enum Keys: String {
        case code
        case rate
        case date
    }
    
    init?(with dictionary: Dictionary<String, Any>) {
        guard let code = dictionary[Keys.code.rawValue] as? String else { return nil }
        
        self.code = code
        rate = dictionary[Keys.rate.rawValue] as? Double
        lastUpdated = dictionary[Keys.date.rawValue] as? Date
    }
    
    var dictionary: Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict[Keys.code.rawValue] = code
        if let rate = rate {
            dict[Keys.rate.rawValue] = rate
        }
        if let date = lastUpdated {
            dict[Keys.date.rawValue] = date
        }
        
        return dict
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
            //	don't override stuff already restored with restoreRates()
            if rates[cc] == nil {
                rates[cc] = Currency(code: cc)
            }
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
        
        fetchCurrencyRate(from: sourceCC,
                          to: targetCC,
                          completionHandler: completionHandler)
    }
    
    private let baseURL = "https://download.finance.yahoo.com/d/quotes.csv?f=sb&s="
    
    fileprivate func singleConversionURL(_ sourceCurrency: String,
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
    
    private let storageURL = FileManager.default.applicationSupportURL
    
    func saveRates() {
        //	save only objects that have rate nono-nil
        
    }
    
    func restoreRates() {
        //	restore from the file, and save into self.rates dictionary
        
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
    
    fileprivate func fetchCurrencyRate(from sourceCC: String,
                                       to targetCC: String,
                                       completionHandler: @escaping (Double?, ExchangeError?) -> Void ) {
        
        let url = singleConversionURL(sourceCC, targetCurrency: targetCC)
        
        //	using shared URL session, make a data task..
        let task = URLSession.shared.dataTask(with: url) {
            data, urlResponse, error in
            
            //	process the returned stuff, now
            if let error = error {
                completionHandler(nil, ExchangeError.networkError(error as NSError?))
                return
            }
            
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
                completionHandler(nil, ExchangeError.invalidResponse)
                return
            }
            
            if httpURLResponse.statusCode != 200 {
                completionHandler(nil, ExchangeError.invalidResponse)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, ExchangeError.invalidResponse)
                return
            }
            
            guard let result = String(data: data, encoding: .utf8) else {
                completionHandler(nil, ExchangeError.invalidResponse)
                return
            }
            
            let lines = result.components(separatedBy: "\n")
            for line in lines {
                let lineParts = line.components(separatedBy: ",")
                guard lineParts.count == 2 else { continue }
                
                guard let currencyCode = lineParts.first?.replacingOccurrences(of: self.baseCurrency, with: "").replacingOccurrences(of: "=X", with: "").replacingOccurrences(of: "\"", with: "") else { continue }
                guard
                    let str = lineParts.last,
                    let currencyRate = Double(str)
                    else { continue }
                
                var currency = self.rates[currencyCode]
                currency?.rate = currencyRate
                currency?.lastUpdated = Date()
                // IMPORTANT!!!!!!!!!!! (Do NOT FORGET!)
                self.rates[currencyCode] = currency
                
            }
            
            do {
                let rate = try self.convert(from: sourceCC, to: targetCC)
                completionHandler(rate, nil)
                return
            } catch(let conversionError) {
                completionHandler(nil, conversionError as? ExchangeError)
            }
            
        }
        //	and execute it
        task.resume()
        
    }
}
