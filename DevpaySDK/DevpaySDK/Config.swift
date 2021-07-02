//
//  Config.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation

public class Config {
    public init(accountId:String,
                shareableKey:String,
                accessKey:String,
                sandbox: Bool = false,
                debug: Bool = false) {
        
        self.accountId = accountId
        self.shareableKey = shareableKey
        self.accessKey = accessKey
        self.sandbox = sandbox
        self.debug = debug
    }
    var accessKey = ""
    var shareableKey = ""
    var accountId = ""
    var sandbox = false
    var debug = false
}
