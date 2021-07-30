//
//  PaymentManager.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation


class PaymentManager {
    
    var restClient: RestClient!
    var config: Config!
    public var paymentIntentSecret: String!

    init(restClient: RestClient, config: Config) {
        self.restClient = restClient
        self.config = config
    }
    
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
    
    private func createIntent(paymentMethod: PaymentMethod,
                              details : PaymentDetail,
                              completion: @escaping CompletionBlock) -> Void {

        var payload = [String:Any]()
        var paymentIntentsInfo = [String:Any]()
        paymentIntentsInfo["amount"] = details.amount
        paymentIntentsInfo["currency"] = details.currency.rawValue
        paymentIntentsInfo["capture_method"] = "automatic"
        paymentIntentsInfo["payment_method_id"] = paymentMethod.id
        paymentIntentsInfo["payment_method_types"] = ["card"]
        paymentIntentsInfo["type"] = "card"
        paymentIntentsInfo["confirm"] = true

        payload["PaymentIntentsInfo"] = paymentIntentsInfo
        payload["RequestDetails"] = requestDetails()

        if let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) {

            restClient.post(path: "/v1/general/paymentintent",
                            data: jsonData) { data, err in
                
                guard let data = self.extractData(data: data, key: "PaymentIntentsResponse") else {
                    let error = self.errorWithMSG(msg: "Failed to create the payment intent", metaData: data)
                    completion(nil,error)
                    return
                }

                let decoder = JSONDecoder()
                
                if let paymentIntent = try? decoder.decode(PaymentIntent.self, from: data) {
                    completion(paymentIntent, err)
                }else{
                    let error = self.errorWithMSG(msg: "Failed to create the payment intent", metaData: data)
                    completion(nil,error)
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
                        
        let payload = [
            "PaymentMethodInfo": dataDictionary,
            "RequestDetails": requestDetails()
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) {
        
            restClient.post(path: "/v1/paymentmethods/create",
                            data: jsonData,
                            headers: [:]) { data, err in
                
                guard let data = self.extractData(data: data, key: "PaymentMethodResponse") else {
                    let error = self.errorWithMSG(msg: "Failed to create the payment method", metaData: data)
                    completion(nil,error)
                    return
                }

                let decoder = JSONDecoder()
                
                if let paymentMethod = try? decoder.decode(PaymentMethod.self, from: data) {
                        completion(paymentMethod, nil)
                }else{
                    let error = self.errorWithMSG(msg: "Failed to create the payment method", metaData: data)
                    completion(nil,error)
                }
            }
        }
    }
        
    typealias PaysafeCompletionBlock = (String?, Error?)->()

    func paysafeAPIKey(completion: @escaping PaysafeCompletionBlock) -> Void {

        let payload = [ "RequestDetails": requestDetails() ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) {
        
        
            restClient.post(path: "/v1/general.svc/paysafe/api-key", data: jsonData) { data, err in
                
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
    }

    func errorWithMSG(msg : String, metaData: Data?) -> NSError {
        var userInfo = [String:Any]()
        userInfo[NSLocalizedDescriptionKey] = msg
        userInfo[NSDebugDescriptionErrorKey] = String(data: metaData ?? Data(), encoding: .utf8) ?? ""
        let error = NSError(domain:"DevPaySDK", code:111, userInfo:userInfo)
        return error
    }
    
    private func requestDetails() -> [String: String] {
        var requestDetails = [
            "DevpayId": config.accountId,
            "token": config.accessKey
        ]
        
        if (config.sandbox) {
            requestDetails["env"] = "sandbox"
        }
        return requestDetails
    }

    func extractData(data : Data?, key : String) -> Data? {
        
        guard let data = data else {
            return nil
        }
        
        if let reponseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
            
            let extractedDict = reponseDict[key]
            guard let extractedDict = extractedDict as? [String:Any] else {
                return nil
            }
            
            if let extractedData = try? JSONSerialization.data(withJSONObject: extractedDict as Any, options: []) {
                return extractedData
            }
        }
        return nil
    }

}
