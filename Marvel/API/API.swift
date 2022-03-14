//
//  APIClass.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.

import Foundation

struct APIDetails {
    static let APIScheme = "https"
    static let APIHost = "gateway.marvel.com"
    static let APIPath = "/v1/public/"
}

class APIClass {
    
    func createURL(parameters: [String:Any], pathparam: String?) -> URL {
        var components = URLComponents()
        components.scheme = APIDetails.APIScheme
        components.host   = APIDetails.APIHost
        components.path   = APIDetails.APIPath
        
        if let paramPath = pathparam {
            components.path = APIDetails.APIPath + "\(paramPath)"
        }
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
}

