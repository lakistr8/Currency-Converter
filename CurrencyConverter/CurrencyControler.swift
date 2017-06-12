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
    
    // views for changed border in cur left/right
    @IBOutlet weak var curLeft : UIView!
    @IBOutlet weak var curRight : UIView!
    func makeCurCircle() {
        //changed border for curLeft view
        self.curLeft.layer.masksToBounds = true
        self.curLeft.layer.cornerRadius  = CGFloat(roundf(Float(self.curLeft.frame.size.width/20)))
        //changed border for curRight view
        self.curRight.layer.masksToBounds = true
        self.curRight.layer.cornerRadius  = CGFloat(roundf(Float(self.curRight.frame.size.width/20)))
    }
    
    //circle view for btn
    @IBOutlet weak var circleViewBtn : UIView!
    func makeItCircle() {
        self.circleViewBtn.layer.masksToBounds = true
        self.circleViewBtn.layer.cornerRadius  = CGFloat(roundf(Float(self.circleViewBtn.frame.size.width/2)))
    }
    
    // Outlet and func for rotate view and button
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var rotationView : UIImageView!
    @IBAction func rotateCurrencyBoxes(_sender:UIButton) {
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            self.rotationView.transform = CGAffineTransform(rotationAngle: 360.0 * CGFloat(M_PI) / 360.0)
        })
    }
    
    
    @IBOutlet weak var decimalButton: UIButton!
    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        defer {
            self.didUntouchButton(sender)
            updateConversionPanel()
        }
        guard let numString = sender.title(for: .normal) else { return }
        var value = sourceCurrencyBox.amountText ?? ""
        
        if value.contains(numString) {
            return
        }
        value += numString
        sourceCurrencyBox.amountText = value
    }
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        defer {
            self.didUntouchButton(sender)
            updateConversionPanel()
        }
        var value = sourceCurrencyBox.amountText ?? ""
        guard value.characters.count > 0 else { return }
        
        var chars = value.characters
        chars.removeLast()
        sourceCurrencyBox.amountText = String(chars)
    }
    
    
    //	= button
    @IBOutlet weak var equalsButton: UIButton!
    //	+, -, *, / operatori
    @IBOutlet var operatorButtons: [UIButton]!
    
    //	numbers
    @IBOutlet var digitButtons: [UIButton]!
    
    // circle border for buttons
    func btnBorders() {
        // equal btn border
        self.equalsButton.layer.masksToBounds = true
        self.equalsButton.layer.cornerRadius  = CGFloat(roundf(Float(self.equalsButton.frame.size.width/20)))
        //operator buttons border
        for btn in operatorButtons {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius  = CGFloat(roundf(Float(btn.frame.size.width/20)))
        }
        // digit buttons border
        for btn in digitButtons {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius  = CGFloat(roundf(Float(btn.frame.size.width/20)))
        }
    }
    
    //	CALCULATIONS
    
    //	definicija tipa: vrsta aritmetičke operacije
    //	vrednost `none` znači da nijedan operator nije trenutno aktivan (tapnut)
    enum ArithmeticOperation {
        case none
        case add, subtract, multiply, divide
        case equals
    }
    
    var activeOperation = ArithmeticOperation.none
    
    //	promenljive za čuvanje unetih brojeva
    //	izabrao sam da budu decimalni brojevi, uvek
    var firstOperand = 0.0
    var secondOperand = 0.0
    
    
    //	CURRENCIES
    
    //	ovo treba da bude referenca na currencybox koji je inicirao promenu
    //	pa onda delegate poziv na osnovu ovoga zna šta da radi
    var changeCurrencyBox : CurrencyBox? = nil
    
    //	sakrijem = button, a prikažem operator
    @IBOutlet weak var leadingCurrencyBox: CurrencyBox!
    @IBOutlet weak var trailingCurrencyBox: CurrencyBox!
    
    var sourceCurrencyBox: CurrencyBox {
        return leadingCurrencyBox
    }
    
    var targetCurrencyBox: CurrencyBox {
        return trailingCurrencyBox
    }
    
    //	data model for the convertor
    var sourceCurrencyCode : String! {
        didSet {
            sourceCurrencyBox.configure(withCurrencyCode: sourceCurrencyCode)
            UserDefaults.sourceCurrencyCode = sourceCurrencyCode
        }
    }
    var targetCurrencyCode : String! {
        didSet {
            targetCurrencyBox.configure(withCurrencyCode: targetCurrencyCode)
            UserDefaults.targetCurrencyCode = targetCurrencyCode
        }
    }
    
    var currencyRate : Double? {
        didSet {
            guard let rate = currencyRate else { return }
            //	update UI
            self.updateConversionPanel()
        }
    }
    
    //	TOUCHES
    
    var buttonOriginalBackgroundColor: UIColor?
}



typealias UISetup = CurrencyControler
extension UISetup {
    
    func assignButtonTaps() {
        for btn in digitButtons {
            btn.addTarget(self, action: #selector(CurrencyControler.digitButtonTapped(_:)), for: .touchUpInside)
        }
        let operators = operatorButtons + [equalsButton]
        for btn in operators {
            btn.addTarget(self, action: #selector(CurrencyControler.operationButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    func assignButtonTargets() {
        let allButtons = digitButtons + operatorButtons + [decimalButton, deleteButton, equalsButton]
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
        self.sourceCurrencyCode = UserDefaults.sourceCurrencyCode ?? "USD"
        self.targetCurrencyCode = UserDefaults.targetCurrencyCode ?? "EUR"
    }
    
    func cleanupUI() {
        //	sakrijem = button, a prikažem operator
        self.equalsButton.alpha = 0
        self.operatorButtons.forEach { (btn) in
            btn.alpha = 1
        }
        
        self.leadingCurrencyBox.textField.text = nil
        self.trailingCurrencyBox.textField.text = nil
    }
    
    func setupCurrencyBoxes() {
        sourceCurrencyBox.delegate = self
        targetCurrencyBox.delegate = self
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
        setupCurrencyBoxes()
        makeItCircle()
        makeCurCircle()
        btnBorders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateConversionRate()
    }

}

typealias Internal = CurrencyControler
extension Internal {
    
    func updateConversionPanel() {
        guard let amountText = sourceCurrencyBox.amountText else { return }
        guard let amount = formatter.number(from: amountText)?.doubleValue else { return }
        guard let rate = currencyRate else { return }
        
        let result = amount * rate
        targetCurrencyBox.amountText = formatter.string(for: result)
    }
    
    
    func updateConversionRate() {
        
        ExchangeManager.shared.rate(for: sourceCurrencyCode, versus: targetCurrencyCode) {
            (returnedRate, error) in
            
            DispatchQueue.main.async {
                if let err = error {
                    //	error display
                    let ac = UIAlertController(title: err.title,
                                               message: err.message,
                                               preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK",
                                           style: .default, handler: nil)
                    ac.addAction(ok)
                    
                    self.present(ac, animated: true, completion: nil)
                    
                    return
                }
                
                self.currencyRate = returnedRate
            }
            
        }
        
    }
    
    func validateOperandInput() -> Double? {
        guard let numString = sourceCurrencyBox.amountText else {
            return nil
        }
        
        let num = formatter.number(from: numString)?.doubleValue
        return num
    }
    
    func digitButtonTapped(_ sender: UIButton) {
        defer {
            self.didUntouchButton(sender)
            updateConversionPanel()
        }
        guard let numString = sender.title(for: .normal) else { return }
        var value = sourceCurrencyBox.amountText ?? ""
        
        value += numString
        sourceCurrencyBox.amountText = value
    }
    
    func operationButtonTapped(_ sender: UIButton) {
        defer {
            self.didUntouchButton(sender)
            updateConversionPanel()
        }
        var isEquals = false
        
        //	dohvati šta piše na buttonu
        guard let caption = sender.title(for: .normal) else {
            fatalError("Received operator button tap from button with no caption on it")
        }
        
        //	pa podesi vrednost prema tome
        switch caption {
        case "+":
            activeOperation = .add
        case "-":
            activeOperation = .subtract
        case "X":
            activeOperation = .multiply
        case "÷":
            activeOperation = .divide
        case "=":
            isEquals = true
        default:
            activeOperation = .none
        }
        
        if (isEquals) {
            //	pritisnut je button =
            //	to znači da je unet drugi operand
            guard let num = validateOperandInput() else {
                sourceCurrencyBox.amountText = nil
                return
            }
            secondOperand = num
            
            //	sada izračunaj operaciju
            var rez = firstOperand
            switch activeOperation {
            case .add:
                rez += secondOperand
            case .subtract:
                rez -= secondOperand
            case .multiply:
                rez *= secondOperand
            case .divide:
                rez /= secondOperand
            default:
                break
            }
            //	i ispiši rezultat u text fieldu
            sourceCurrencyBox.amountText = formatter.string(for: rez)
            
            //	clear-out placeholders
            firstOperand = 0
            secondOperand = 0
            
            //	reveal the operator buttons again and hide EQUALS button
            UIView.animate(withDuration: 0.4, animations: {
                self.equalsButton.alpha = 0
                self.operatorButtons.forEach { (btn) in
                    btn.alpha = 1
                }
            })
            
            
        } else if activeOperation != .none {
            
            //	pritisnut je neki od aritm. operatora
            //	to znači da je unet prvi operand
            guard let num = validateOperandInput() else {
                sourceCurrencyBox.amountText = nil
                return
            }
            firstOperand = num
            //	obriši prikaz i time se spremi za unos drugog operanda
            sourceCurrencyBox.amountText = nil
            
            //	hide all the oprator buttons and reveal EQUALS button
            UIView.animate(withDuration: 0.25, animations: {
                self.equalsButton.alpha = 1
                self.operatorButtons.forEach { (btn) in
                    btn.alpha = 0
                }
            })
        }
    }
}



extension CurrencyControler : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
}

extension CurrencyControler: CurrencyBoxDelegate {
    
    func currencyBoxInitiatedChange(_ currencyBox: CurrencyBox) {
        //	save who requested the change
        changeCurrencyBox = currencyBox
        
        //	load and display the controller, without storyboard
        let storyboard = UIStoryboard(name: "CurrencyConverter", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CurrencyPicker") as? CurrencyPicker else {
            fatalError("Failed to create instance of CurrencyPickerController from \(storyboard)")
        }
        vc.delegate = self
        show(vc, sender: self)
    }

}

extension CurrencyControler: CurrencyPickerControllerDelegate {
    
    func currencyPicker(controller: CurrencyPicker, didSelect currencyCode: String) {
        //	ok, now update as needed
        guard let changeBox = changeCurrencyBox else { return }
        
        if changeBox === sourceCurrencyBox {
            sourceCurrencyCode = currencyCode
        } else {
            targetCurrencyCode = currencyCode
        }
        changeCurrencyBox = nil
        
        _ = navigationController?.popViewController(animated: true)
    }
}
