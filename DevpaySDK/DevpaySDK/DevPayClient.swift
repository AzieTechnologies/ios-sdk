//
//  DevPayClient.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation

public class DevpayClient {
     
    var config:Config!
    var paymentManager:PaymentManager!
    var paysafeClient:PaysafeClient!
    
    public init(config: Config) {
        self.config = config
        let restClient = restClientDevPay()
        paymentManager = PaymentManager(restClient: restClient, config: config)
        paymentManager.paymentIntentSecret = config.accessKey
    }
    
    public typealias PaymentConfirmationCompletion = (PaymentIntent?,Error?)->()
    
    public func confirmPayment(details: PaymentDetail,
                               completion: @escaping  PaymentConfirmationCompletion) -> Void {
        
        self.paymentManager.paysafeAPIKey() { key, err in
            
            if err != nil {
                completion(nil, err)
            } else if let key = key {
                
                let restClient = self.restClientPaysafe(key: key)
                self.paysafeClient = PaysafeClient(restClient: restClient)
                
                self.paysafeClient.tokenize(paymentDetail: details) { paymentToken, error in
                    
                    if let paymentToken = paymentToken {
                        
                        self.confirmPayment(token: paymentToken,
                                            details: details,
                                            completion:completion)
                        
                    }else {
                        let error = NSError(domain:"DevPaySDK", code:0, userInfo:nil)
                        completion(nil, error)
                    }
                }
            }else{
                let error = NSError(domain:"DevPaySDK", code:0, userInfo:nil)
                completion(nil, error)
            }
        }
    }
    
    private func confirmPayment(token:String,
                                details:PaymentDetail,
                                completion: @escaping  PaymentConfirmationCompletion) {
        
        self.paymentManager.confirmPayment(paymentToken: token,
                                           details: details) { intent, err in
            completion(intent, err)
        }
    }
    
    private func restClientDevPay() -> RestClient {
        let headers = ["Content-Type":"application/json"]

        let baseURL = "https://api.devpay.io"
        let restClient = RestClient(baseURL: baseURL,
                                    headers: headers)
        restClient.debug = self.config.debug
        return restClient
    }

    private func restClientPaysafe(key: String) -> RestClient {
        
        let headers = ["X-Paysafe-Credentials":"Basic " + key,
                       "Content-Type":"application/json"
        ]
        var baseURL = "https://hosted.paysafe.com"
        if self.config.sandbox {
            baseURL = "https://hosted.test.paysafe.com"
        }

        let restClient = RestClient(baseURL: baseURL,
                                    headers: headers)
        restClient.debug = self.config.debug
        return restClient
    }
}
