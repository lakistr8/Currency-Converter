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
    
    enum ArithmeticOperation {
        case none
        case add, subtract, multiply, divide
        case equals
    }
    
    var activeOperation = ArithmeticOperation.none
    
    var firstOperand = 0.0
    var secondOperand = 0.0
}



typealias UISetup = CurrencyControler
extension UISetup {
    
    func assignButtonTaps() {
        for btn in digitButtons {
            btn.addTarget(self, action: #selector(CurrencyControler.digitButtonTapped(_:)), for: .touchUpInside)
        }
        for btn in operatorButtons {
            btn.addTarget(self, action: #selector(CurrencyControler.operationButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
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
    
    func cleanupUI() {
        
    }
    
}




typealias ViewLifecycle = CurrencyControler
extension ViewLifecycle {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.navigationItem.title?.uppercased()
        
        assignButtonTargets()
        configureDecimalButton()
        cleanupUI()
    }
}



extension CurrencyControler : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

}
