//
//  PaymentDetail.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation

public class BillingAddress {
    
    public var country:String?
    public var zip:String?
    public var state:String?
    public var city:String?
    public var street:String?
    
    public init(street: String,
                city:String,
                zip:String,
                state: String,
                country:String) {
        self.street = street
        self.city = city
        self.zip = zip
        self.state = state
        self.country = country
    }
    
    public func asDictionary() -> [String:Any] {
        var billingAddrDict = [String:String]()
        billingAddrDict["street"] =  self.street
        billingAddrDict["city"] = self.city
        billingAddrDict["country"] = self.country
        billingAddrDict["zip"] = self.zip
        billingAddrDict["state"] = self.state
        return billingAddrDict
    }

}

public enum Currency: String {
    case USD  = "usd"
    case AUD  = "aud"
    case CAD  = "cad"
    case DKK  = "dkk"
    case EUR  = "eur"
    case HKD  = "hkd"
    case JPY  = "jpy"
    case NZD  = "nzd"
    case NOK  = "nok"
    case GBD  = "gbp"
    case ZAR  = "zar"
    case SEK  = "sek"
    case XCHF = "chf"
}

public class PaymentDetail {

    var amount:Int!
    var currency:Currency!
    var name:String!
    var billingAddress:BillingAddress?
    var card:Card!
    
    public var metaData:[String:String]?

    public init(amount: Int,
                currency: Currency,
                name: String,
                card:Card,
                billingAddress: BillingAddress) {
        self.amount = amount
        self.currency = currency
        self.name = name
        self.billingAddress = billingAddress
        self.card = card
    }
}
