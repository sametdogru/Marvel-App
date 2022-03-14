//
//  CharacterListRespository.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.
//

import Foundation

struct Repository {
    
    func getCharacterList(request:CharacterRequest, completion: @escaping(_ result: CharacterResponse?, _ error:String?) -> Void) {
        let dict = Configuration().getApiKeys()
        let url = APIClass.init().createURL(parameters: ["apikey" : dict[Constants.publicApiKey] ?? "" ,"hash": request.hash,"limit":request.limit ?? 0,"ts":request.ts], pathparam: "characters")
        let urlRequest = URLRequest(url:url)
        
        let task = URLSession.shared.dataTask(with:urlRequest) { (data,response,error) in
            DispatchQueue.main.async {
                if error == nil {
                    guard let data = data,let response = try? JSONDecoder().decode(CharacterResponse.self, from: data)
                        else {
                            completion(nil,ErrorMessage.errorInDataObject)
                            return
                    }
                    completion(response,ErrorMessage.noError)
                }
                else {
                    completion(nil,error?.localizedDescription)
                }
            }
        }
        task.resume()
    }

    func getCharacterDetails(request:CharacterRequest, characterId:Int, completion: @escaping(_ result: CharacterModel?,_ error:String?) -> Void) {
        let dict = Configuration().getApiKeys()
        let url = APIClass.init().createURL(parameters: ["apikey" : dict[Constants.publicApiKey] ?? "" ,"hash": request.hash,"ts":request.ts], pathparam:("characters/" + "\(String(characterId))"))
        let urlRequest = URLRequest(url:url)
        
        let task = URLSession.shared.dataTask(with:urlRequest) { (data,response,error) in
            DispatchQueue.main.async {
                if error == nil {
                    guard let data = data,let response = try? JSONDecoder().decode(CharacterResponse.self, from: data)
                        else {
                            completion(nil,ErrorMessage.errorInDataObject)
                            return
                    }
                    completion(response.data.results.first,ErrorMessage.noError)
                }
                else {
                    completion(nil,error?.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
