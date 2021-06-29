//
//  PaysafeClient.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation

class PaysafeClient {
    
    var restClient :RestClient!
    
    typealias CompletionBlock = (String?, Error?)->()
    init(restClient :RestClient) {
        self.restClient = restClient
    }
    
    func tokenize(paymentDetail: PaymentDetail,completion: @escaping CompletionBlock) {
        
        var dataDictionary = [String:Any]()
        dataDictionary["amount"] = String(format: "%ld", paymentDetail.amount ?? "0")
        dataDictionary["currency"] = paymentDetail.currency?.rawValue
        dataDictionary["name"] = paymentDetail.name
        
        // Card
        var cardDict = [String:Any]()
        cardDict["cardNum"] = paymentDetail.card?.cardNum
        cardDict["cardExpiry"] = ["month":paymentDetail.card?.expiryMonth,
                                  "year":paymentDetail.card?.expiryYear]
        cardDict["cvv"] = paymentDetail.card?.cvv
        
        // Billing address
        var billingAddrDict = [String:String]()
        billingAddrDict["street"] =  paymentDetail.billingAddress?.street
        billingAddrDict["city"] = paymentDetail.billingAddress?.city
        billingAddrDict["country"] = paymentDetail.billingAddress?.country
        billingAddrDict["zip"] = paymentDetail.billingAddress?.zip
        billingAddrDict["state"] = paymentDetail.billingAddress?.state

        
        dataDictionary["card"] = cardDict
        dataDictionary["billingAddress"] = billingAddrDict
        
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dataDictionary, options: []) {
            
            self.restClient.post(path: "/js/api/v1/tokenize",
                                 data: jsonData,
                                 headers:[:]) { data, err in
                
                if (err != nil) {
                    completion(nil,err)
                    return
                }
                
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        if let apiKey = json["paymentToken"] as? String {
                            completion(apiKey,nil)
                        }else{
                            let error = self.errorWithMSG(msg: "No token available in response", metaData: data)
                            completion(nil,error)
                        }
                    }else{
                        let error = self.errorWithMSG(msg: "No token available in response", metaData: data)
                        completion(nil,error)
                    }
                }else{
                    let error = self.errorWithMSG(msg: "No token available in response", metaData: nil)
                    completion(nil,error)
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

}
