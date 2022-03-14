//
//  Configuration.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.
//

import Foundation

struct Configuration {
    func getApiKeys() -> [String:String] {
        
        if let path = Bundle.main.path(forResource:"Configuration", ofType: "plist") {
            let plist = NSDictionary(contentsOfFile: path) ?? ["":""]
            let publicKey = plist["Public_API_Key"] as! String
            let privateKey = plist["Private_API_Key"] as! String
            let dict = [Constants.publicApiKey:publicKey,Constants.privateApiKey:privateKey]
            return dict
        }
        return ["":""]
    }
}


