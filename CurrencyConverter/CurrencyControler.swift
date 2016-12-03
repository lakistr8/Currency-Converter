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
    
    let formatter : NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()

    
    
    @IBOutlet weak var decimalButton: UIButton!
    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        defer {
            self.didUntouchButton(sender)
        }
    }
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        defer {
            self.didUntouchButton(sender)
        }
    }
    
    
    @IBOutlet weak var equalsButton: UIButton!
    
    @IBOutlet var operatorButtons: [UIButton]!
    func operationButtonTapped(_ sender: UIButton) {
        defer {
            self.didUntouchButton(sender)
        }
    }
    
    
    @IBOutlet var digitButtons: [UIButton]!
    func digitButtonTapped(_ sender: UIButton) {
        defer {
            self.didUntouchButton(sender)
        }
    }
    
    var buttonOriginalBackgroundColor: UIColor?
    
    enum ArithmeticOperation {
        case none
        case add, subtract, multiply, divide
        case equals
    }
    
    
    var activeOperation = ArithmeticOperation.none
    
    var firstOperand = 0.0
    var secondOperand = 0.0
    
    @IBOutlet weak var leadingCurrencyBox: CurrencyBox!
    @IBOutlet weak var trailingCurrencyBox: CurrencyBox!
    
    var sourceCurrencyBox: CurrencyBox {
        return leadingCurrencyBox
    }
    
    var targetCurrencyBox: CurrencyBox {
        return trailingCurrencyBox
    }
    
    var sourceCurrencyCode : String! {
        didSet {
            sourceCurrencyBox.configure(withCurrencyCode: sourceCurrencyCode)
        }
    }
    var targetCurrencyCode : String! {
        didSet {
            targetCurrencyBox.configure(withCurrencyCode: targetCurrencyCode)
        }
    }
    var currencyRate : Double?
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
        buttonOriginalBackgroundColor = sender.backgroundColor
        
        //	first, if there is no color, then use very transparent black
        guard let _ = sender.backgroundColor else {
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            return
        }
        
        //	Since buttons backgrounds are already partially transparent,
        //	we need to increase the alpha part, in order to visualize tapping
        
        //	here's a way to extract RGBA components from the UIColor
        //	setup default (black)
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        //	and use 20% opacity
        var a : CGFloat = 0.2
        //	this method will populate the components above using given UIColor value
        guard let _ = sender.backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            //	if extraction fails, then fall back to black, as above
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            return
        }
        //	if it worked, then setup using double alpha
        sender.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: a*2)
    }
    
    func didUntouchButton(_ sender: UIButton) {
        sender.backgroundColor = buttonOriginalBackgroundColor
        buttonOriginalBackgroundColor = nil
    }
    
    func configureDecimalButton() {
        let locale = NSLocale.current
        guard let decimalSign = locale.decimalSeparator else { return }
        decimalButton.setTitle(decimalSign, for: .normal)
    }
    
    func setupInitialCurrencies() {
        self.sourceCurrencyCode = "USD"
        self.targetCurrencyCode = "EUR"
    }
    
    func cleanupUI() {
        self.equalsButton.alpha = 0
        self.operatorButtons.forEach { (btn) in
            btn.alpha = 1
        }
        
        self.leadingCurrencyBox.textField.text = nil
        self.trailingCurrencyBox.textField.text = nil
    }
    
}




typealias ViewLifecycle = CurrencyControler
extension ViewLifecycle {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.navigationItem.title?.uppercased()
        
        assignButtonTargets()
        assignButtonTaps()
        configureDecimalButton()
        cleanupUI()
        setupInitialCurrencies()
    }
}

typealias Internal = CurrencyControler
extension Internal {
    
//    func validateOperandInput() -> Double? {
//        //		guard let numString = resultField.text else {
//        //			return nil
//        //		}
//        //
//        //		let num = formatter.number(from: numString)?.doubleValue
//        //		return num
//        return 0
//    }
//    
//    func digitButtonTapped(_ sender: UIButton) {
//    defer {
//    self.didUntouchButton(sender)
//    }
//        guard let numString = sender.title(for: .normal) else { return }
//        var value = resultField.text ?? ""
//
//        defer {
//            self.didUntouchButton(sender)
//        }
//        
//        value += numString
//        resultField.text = value
//    }
    
//    func operationButtonTapped(_ sender: UIButton) {
//    
//    defer {
//    self.didUntouchButton(sender)
//    }
//        var isEquals = false
//        
//        
//        guard let caption = sender.title(for: .normal) else {
//            fatalError("Received operator button tap rom button with no caption on it")
//        }
//        
//        
//        switch caption {
//        case "+":
//            activeOperation = .add
//        case "-":
//            activeOperation = .subtract
//        case "×":
//            activeOperation = .multiply
//        case "÷":
//            activeOperation = .divide
//        case "=":
//            isEquals = true
//        default:
//            activeOperation = .none
//        }
//        
//        if (isEquals) {
//            
//            guard let num = validateOperandInput() else {
//                resultField.text = nil
//                return
//            }
//            secondOperand = num
//            
//            
//            var rez = firstOperand
//            switch activeOperation {
//            case .add:
//                rez += secondOperand
//            case .subtract:
//                rez -= secondOperand
//            case .multiply:
//                rez *= secondOperand
//            case .divide:
//                rez /= secondOperand
//            default:
//                break
//            }
//            
//            resultField.text = formatter.string(for: rez)
//            
//            
//            firstOperand = 0
//            secondOperand = 0
//            
//        } else if activeOperation != .none {
//            
//            
//            guard let num = validateOperandInput() else {
//                resultField.text = nil
//                return
//            }
//            firstOperand = num
//            
//            resultField.text = nil
//        }
//        
//        self.didUntouchButton(sender)
//    }
}


extension CurrencyControler : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

}
