//
//  PaymentIntent.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation

public class PaymentIntent : Decodable {
    
    let accountId : String?
    let amount : Int?
    let amountCapturable : Int?
    let amountReceived : Int?
    let captureMethod : String?
    let clientSecret : String?
    let currency : String?
    let id : String?
    let paymentMethodTypes : [String]?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case amount = "amount"
        case amountCapturable = "amount_capturable"
        case amountReceived = "amount_received"
        case captureMethod = "capture_method"
        case clientSecret = "client_secret"
        case currency = "currency"
        case id = "id"
        case paymentMethodTypes = "payment_method_types"
        case platformFeeAmount = "platform_fee_amount"
        case status = "status"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountId = try values.decodeIfPresent(String.self, forKey: .accountId)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        amountCapturable = try values.decodeIfPresent(Int.self, forKey: .amountCapturable)
        amountReceived = try values.decodeIfPresent(Int.self, forKey: .amountReceived)
        captureMethod = try values.decodeIfPresent(String.self, forKey: .captureMethod)
        clientSecret = try values.decodeIfPresent(String.self, forKey: .clientSecret)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        paymentMethodTypes = try values.decodeIfPresent([String].self, forKey: .paymentMethodTypes)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
