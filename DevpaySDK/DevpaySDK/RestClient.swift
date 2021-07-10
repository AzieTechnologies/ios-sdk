//
//  RestClient.swift
//  DevPaySDK
//
//  Created by DevPay 
//

import Foundation

class RestClient {

    typealias CompletionBlock = (Data?, Error?)->()

    var debug = false
    var baseURL:String!
    var headers:[String:String]!

    init(baseURL:String!,headers:[String:String]!) {
        self.baseURL = baseURL
        self.headers = headers
    }
    
    func post(path: String,
              data: Data,
              headers:[String:String]? = [:],
            completion: @escaping CompletionBlock) -> Void {
        
        let url = URL(string: baseURL+path);
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = data
                
        self.logMsg(prefix: "DevPaySDK - Request url: ",
                    stringData: url?.absoluteString ?? "",
                    data: nil)

        self.logMsg(prefix: "DevPaySDK - Request Data: ", data: data)

        // Set global headers
        self.headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Set request specific headers
        headers?.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            
            self.logMsg(prefix: "DevPaySDK - Response: ", data: data, err: err)
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
    }

    func get(path: String,
             headers:[String:String],
             completion: @escaping CompletionBlock) -> Void {
        
        let url = URL(string: baseURL+path);
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        // Set global headers
        self.headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set request specific headers
        headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        self.logMsg(prefix: "DevPaySDK - Request url: ",
                    stringData: url?.absoluteString ?? "",
                    data: nil)

        let task = URLSession.shared.dataTask(with: request) { data, response, err in

            self.logMsg(prefix: "DevPaySDK - Response: ", data: data, err: err)
            DispatchQueue.main.async {
                completion(data, err)
            }
        }
        task.resume()
    }
    
    func logMsg(prefix: String,stringData: String = "",data : Data?, err : Error? = nil) -> Void {
        if debug {
            if let data = data {
                let msg = String(data: data, encoding: .utf8) ?? ""
                print(prefix+msg)
            }
            
            if let err = err {
                print("DevPaySDK: "+err.localizedDescription)
            }
        }
    }
}
