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
    
    
    @IBOutlet weak var decimalButton: UIButton!
    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var equalsButton: UIButton!
    
    @IBOutlet var operatorButtons: [UIButton]!
    func operationButtonTapped(_ sender: UIButton) {
        
    }
    
    
    @IBOutlet var digitButtons: [UIButton]!
    func digitButtonTapped(_ sender: UIButton) {
        
    }
}



typealias UISetup = CurrencyControler
extension UISetup {
    
    func assignButtonTargets() {
        let allButtons = digitButtons + operatorButtons + [decimalButton, deleteButton]
        for btn in allButtons {
            btn.addTarget(self, action: #selector(CurrencyControler.didTouchButton(_:)), for: .touchDown)
            
            btn.addTarget(self, action: #selector(CurrencyControler.didUntouchButton(_:)), for: .touchCancel)
            btn.addTarget(self, action: #selector(CurrencyControler.didUntouchButton(_:)), for: .touchUpOutside)
        }
    }
    
    func didTouchButton(_ sender: UIButton) {
        //		guard let bgColor = sender.backgroundColor else { return }
        //		originalBackgroundColor = bgColor
        //		let newColor = bgColor.withAlphaComponent(0.96)
        //		sender.backgroundColor = newColor
    }
    
    func didUntouchButton(_ sender: UIButton) {
        //		guard let bgColor = originalBackgroundColor else { return }
        //		sender.backgroundColor = bgColor
        //		originalBackgroundColor = nil
    }
    
    func configureDecimalButton() {
        let locale = NSLocale.current
        guard let decimalSign = locale.decimalSeparator else { return }
        decimalButton.setTitle(decimalSign, for: .normal)
    }
    
}




typealias ViewLifecycle = CurrencyControler
extension ViewLifecycle {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.navigationItem.title?.uppercased()
        
        assignButtonTargets()
        configureDecimalButton()
    }
}



extension CurrencyControler : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

}
