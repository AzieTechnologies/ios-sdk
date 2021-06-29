//
//  PaymentMethod.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation

class PaymentMethod : Decodable {
    
    var id:String = ""
    var type: String = ""

    enum CodingKeys: String, CodingKey {
        case  id, type
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        type = try values.decode(String.self, forKey: .type)
    }
}
