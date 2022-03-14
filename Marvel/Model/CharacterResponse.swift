//
//  CharacterResponse.swift
//
//  Created by Samet Doğru on 14.03.2022.

import Foundation

struct CharacterResponse:Codable {
    var data:Result
}

class Result:Codable {
    var results:[CharacterModel]
}

struct CharacterModel:Codable {
    var id:Int
    var name:String
    var description:String
    var thumbnail:Thumbnail
    var comics:Comics
}

struct Comics:Codable {
    var available:Int
    var items:[Items]
}

struct Items:Codable {
    var resourceURI:String
    var name:String
}

struct Thumbnail:Codable {
    var path:String
    var imageExtension:String
    
    private enum CodingKeys : String, CodingKey {
        case path,imageExtension = "extension"
    }
}
