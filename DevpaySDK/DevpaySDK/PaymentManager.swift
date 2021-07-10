//
//  PaymentManager.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation


class PaymentManager {
    
    var restClient: RestClient!
    public var paymentIntentSecret: String!

    init(restClient: RestClient) {
        self.restClient = restClient
    }
    
    typealias DevPayIntentCompletionBlock = (Bool?, Error?)->()
    typealias CompletionBlock = (PaymentIntent?, Error?)->()
    typealias PaymentMethodCompletionBlock = (PaymentMethod?, Error?)->()

    public func confirmPayment(paymentToken : String,
                        details : PaymentDetail,
                        completion: @escaping CompletionBlock) -> Void {
        
        createMethod(paymentToken: paymentToken,
                     details: details) { payMethod, err in
            
            
            self.createIntent(paymentMethod: payMethod!,
                         details: details) { intent, err in
                completion(intent, err)
            }
        }
    }
    
    public func createDevpayIntent(config: Config,
                                   details : PaymentDetail,
                               restClient : RestClient,
                               completion: @escaping DevPayIntentCompletionBlock) -> Void {

        var payload = [String:Any]()
        var paymentIntentsInfo = [String:Any]()
        paymentIntentsInfo["amount"] = details.amount
        paymentIntentsInfo["currency"] = details.currency.rawValue
        paymentIntentsInfo["capture_method"] = "automatic"
        paymentIntentsInfo["payment_method_types"] = ["card"]

        var requestDetails = [String:Any]()
        requestDetails["DevpayId"] = config.accountId
        if config.sandbox {
            requestDetails["env"] = "sandbox"
        }
        requestDetails["token"] = config.accessKey
        payload["PaymentIntentsInfo"] = paymentIntentsInfo
        payload["RequestDetails"] = requestDetails

        if let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) {

            restClient.post(path: "/v1/general/paymentintent",
                            data: jsonData) { data, err in
                
                if err != nil {
                    completion(false,err)
                }else{
                    
                    if let data = data {
                    
                        if let reponseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                            
                            if let response = reponseDict[ "Response"] as? [String:Any] {
                                
                                if response["status"] as? Int == 1 {
                                    completion(true,nil)
                                    return
                                }

                            }
                        }
                    }
                    let error = self.errorWithMSG(msg: "Failed to create the dev-pay payment intent", metaData: data)
                    completion(false,error)

                }
                
            }

        }
        
    }

    private func createMethod(paymentToken : String,
                              details : PaymentDetail,
                        completion: @escaping PaymentMethodCompletionBlock) -> Void {
        
                
        var dataDictionary = [String:Any]()
        dataDictionary["payment_token"] = paymentToken
        dataDictionary["type"] = "card"
        
        var billingDetailsDict = [String:Any]()
        billingDetailsDict["amount"] = details.amount
        billingDetailsDict["currency"] = details.currency.rawValue
        billingDetailsDict["address"] = details.billingAddress?.asDictionary()
        dataDictionary["billing_details"] = billingDetailsDict;
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dataDictionary, options: []) {
        
            restClient.post(path: "/v1/payment-methods",
                            data: jsonData,
                            headers: [:]) { data, err in
                 
                let decoder = JSONDecoder()
                
                if let paymentMethod = try? decoder.decode(PaymentMethod.self, from: data!) {
                        completion(paymentMethod, nil)
                }else{
                    let error = self.errorWithMSG(msg: "Failed to create the payment method", metaData: data)
                    completion(nil,error)
                }

            }

        }
        
    }

    private func createIntent(paymentMethod: PaymentMethod,
                              details : PaymentDetail,
                              completion: @escaping CompletionBlock) -> Void {
        
        var dataDictionary = [String:Any]()
        dataDictionary["amount"] = details.amount
        dataDictionary["currency"] = details.currency?.rawValue
        dataDictionary["capture_method"] = "automatic"
        dataDictionary["payment_method_types"] = ["card"]
        dataDictionary["payment_method_id"] = paymentMethod.id
        dataDictionary["confirm"] = true
        if let metaData = details.metaData {
            dataDictionary["metadata"] = metaData
        }

        var headers = [String:String]()
        headers["Authorization"] = "Bearer " + paymentIntentSecret

        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dataDictionary, options: []) {
            
            restClient.post(path: "/v1/payment-intents",
                            data: jsonData,
                            headers: headers) { data, err in
                
                let decoder = JSONDecoder()
                
                if let paymentIntent = try? decoder.decode(PaymentIntent.self, from: data!) {
                    completion(paymentIntent, err)
                }else{
                    let error = self.errorWithMSG(msg: "Failed to create the payment intent", metaData: data)
                    completion(nil,error)
                }
                
            }
            
        }

    }
    
    
    typealias PaysafeCompletionBlock = (String?, Error?)->()

    func paysafeAPIKey(completion: @escaping PaysafeCompletionBlock) -> Void {
        
        restClient.get(path: "/v1/payment-providers/paysafe/api-key",
                       headers: [:]) { data, err in
            
            do {
                
                if let data = data {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        if let apiKey = json["provider_api_key"] as? String {
                            completion(apiKey,nil)
                        }else {
                            let error = self.errorWithMSG(msg: "No Provider key available in response", metaData: data)
                            completion(nil,error)
                        }
                    }
                }else{
                    let error = self.errorWithMSG(msg: "No Provider key available in response", metaData: nil)
                    completion(nil,error)
                }
                
            } catch let error as NSError {
                completion(nil, error)
            }

        }
    }

    func errorWithMSG(msg : String, metaData: Data?) -> NSError {
        var userInfo = [String:Any]()
        userInfo[NSLocalizedDescriptionKey] = msg
        userInfo[NSDebugDescriptionErrorKey] = String(data: metaData ?? Data(), encoding: .utf8) ?? ""
        let error = NSError(domain:"DevPaySDK", code:111, userInfo:userInfo)
        return error
    }
}
