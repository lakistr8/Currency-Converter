//
//  CurrencyConcerter.swift
//  CurrencyConverter
//
//  Created by iosakademija on 12/2/16.
//  Copyright © 2016 iosakademija. All rights reserved.
//

import UIKit

class CurrencyControler: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.navigationItem.title?.uppercased()
    }
}

extension CurrencyControler : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

}
