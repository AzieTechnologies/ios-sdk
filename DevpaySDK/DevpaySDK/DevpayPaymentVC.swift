//
//  PaymentInputUI.swift
//  DevPaySDK
//
//  Created by DevPay on 19/06/21.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

@available(iOS 9.0, *)
class BottomBorderTF: UITextField {
    
    var bottomBorder = UIView()
    let bottomLine = CALayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

public class DevpayPaymentVC: UITableViewController {
    
    public typealias OnPayAction = (PaymentDetail)->()
    
    var _onPayAction:OnPayAction!
    public var onPayAction:OnPayAction! {
        set {
            _onPayAction = newValue
        }
        get{
            return _onPayAction
        }
    }
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cardNumTf: UITextField!
    @IBOutlet weak var expiryTf: UITextField!
    @IBOutlet weak var cvvTf: UITextField!
    
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var zipTf: UITextField!
    @IBOutlet weak var cityTf: UITextField!
    @IBOutlet weak var streetTf: UITextField!
    
    @IBOutlet weak var countryTf: UITextField!
    @IBOutlet weak var stateTf: UITextField!
    
    var appUsesIQKeyboardManager = false
    
    public var amount:Int!
    public var currency:Currency!
    var customPayBtnTitle:String?

    public override func viewWillAppear(_ animated: Bool) {
        appUsesIQKeyboardManager = IQKeyboardManager.shared.enable
        IQKeyboardManager.shared.enable = true
        super.viewWillAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = appUsesIQKeyboardManager
    }
    
    public override func viewDidLoad() {
        self.submitBtn.setTitle("PAY", for: .normal)
        
        self.title = "Payment Details"
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkGray]

        self.submitBtn.backgroundColor = UIColor(red: 22/255.0, green: 13/255.0, blue: 215/255.0, alpha: 1.0)

        self.submitBtn.layer.cornerRadius = 6.0;
        
        // Debug setup
        self.cardNumTf.placeholder = "XXXXYYYYXXXXYYYY"
        self.cvvTf.placeholder = "XYZ"
        self.expiryTf.placeholder = "MM/YYYY"
        
        self.cityTf.placeholder = "Memphis"
        self.streetTf.placeholder = "123 ABC Lane"
        self.stateTf.placeholder = "TN"
        self.countryTf.placeholder = "US"
        self.zipTf.placeholder = "38138"
        
        self.nameTf.placeholder = "John doe"

    }
    
    public static func instance() -> DevpayPaymentVC {
        let bundle = Bundle(for: self)
        
        let storyboard = UIStoryboard(name: "DevpayUI", bundle: bundle)
        let customViewController = storyboard.instantiateViewController(withIdentifier: "DevpayPaymentVC") as!DevpayPaymentVC
        return customViewController
    }
    
    @IBAction func payAction(button: UIButton) {
        
        if (self.cardNumTf.text?.count == 0 ||
                self.cvvTf.text?.count == 0 ||
                self.expiryTf.text?.count == 0 ||
                self.cityTf.text?.count == 0 ||
                self.streetTf.text?.count == 0 ||
                self.stateTf.text?.count == 0 ||
                self.countryTf.text?.count == 0 ||
                self.zipTf.text?.count == 0 ||
                self.nameTf.text?.count == 0) {
            
            let alert = UIAlertController(title: "Message", message: "Please provide all the details in correct format", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if self.expiryTf.text?.count ?? 0 < 6 {
            let alert = UIAlertController(title: "Message", message: "Please input expiry in the correct format", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let expiryMonth = self.expiryTf.text!.split(separator: "/").first!
        let expiryYear = self.expiryTf.text!.split(separator: "/").last!
        let card = Card(cardNum: self.cardNumTf.text!,
                        expiryMonth: String(expiryMonth),
                        expiryYear: String(expiryYear),
                        cvv: self.cvvTf.text!)
        
        let billingAddr = BillingAddress(street: self.streetTf.text!,
                                         city: self.cityTf.text!,
                                         zip: self.zipTf.text!,
                                         state: self.stateTf.text!,
                                         country: self.countryTf.text!)
        
        let paymentDetails = PaymentDetail(amount: amount,
                               currency: currency,
                               name: self.nameTf.text!,
                               card: card,
                               billingAddress: billingAddr)
        _onPayAction(paymentDetails)
    }
}
