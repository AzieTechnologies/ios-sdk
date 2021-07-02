//
//  ViewController.swift
//  DevPaySDKSample
//
//  Created by DevPay 
//

import UIKit
import DevpaySDK

class ViewController: UIViewController {
    
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet var payBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func payAction(button: UIButton){
        
        let config = Config(accountId: "acct_IcE3FBKFM734gHqvICa9Q",
                            shareableKey: "pk_a6D7pvEKx8qMBVD8NfaUlX3pfl7QqrJ53jstYswlXhVwOQm7qgcjITSTJcsrndhJfu6k3OtHMep3HAw6vANaCfLZtwBXwuT9qrrq",
                            accessKey: "sk_AdBRPUKdcM2QbyS5VT2yQJaIPTl6etzP2mK0ojKhM0xJ8PBMwxbZqzfmrIzv8Ukzf3NtpgbIoH119Fm21dVDCV32CZr3koGwb8OP",
                            sandbox: true)

        let payClient = DevpayClient(config: config)
        
        let devPayVC = DevpayPaymentVC.instance()
        let amountNumber = self.amountTf!.text;
        devPayVC.amount = Int(amountNumber ?? "")
        devPayVC.currency = .USD
        
        devPayVC.onPayAction = { pd in
            
            pd.metaData = ["client":"dev-pay ios sdk"]
            payClient.confirmPayment(details: pd) { intent, err in
                
                if err != nil {
                    print("Error \(String(describing: err))")
                }else {
                    print("Payment successful \(String(describing: intent))")
                }
            }
        }
        
        let navigation = UINavigationController(rootViewController: devPayVC)

        devPayVC.closeAction = {
            navigation.dismiss(animated: true, completion: nil)
        }
        
        self.present(navigation, animated: true, completion: nil)
    }
    
}

