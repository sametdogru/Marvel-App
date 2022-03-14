//
//  CharacterRequest.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.
//

import Foundation
import CommonCrypto

struct CharacterRequest:Encodable {
    let hash:String
    let ts:String
    let limit:Int?
}

extension Date {
    func generateTimeStamp() -> String {
        let timeStamp = NSDate().timeIntervalSince1970.description
        return timeStamp
    }
}

extension String {
    func generateMd5HashValue(timestamp: String) -> String {
        let dict = Configuration().getApiKeys()
        let paramString = (timestamp + (dict[Constants.privateApiKey] ?? "") + (dict[Constants.publicApiKey] ?? ""))
        let str = paramString.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(paramString.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
}







