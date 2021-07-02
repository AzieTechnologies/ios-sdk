//
//  Card.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation

public class Card {
    
    public var cardNum:String!
    public var cvv:String!
    public var expiryMonth:String!
    public var expiryYear:String!
    
    public init(cardNum:String,
                expiryMonth:String,
                expiryYear:String,
                cvv:String) {
        
        self.cardNum = cardNum
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
    }

}
