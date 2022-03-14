//
//  CharacterViewModel.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.

import Foundation

protocol CharacterViewModelDelegate {
    func didReceiveResponse(dataResponse:[CharacterModel]?)
    func didFailWithError(msg:String)
}

struct CharacterViewModel {
    
    var delegate:CharacterViewModelDelegate?
    
    func fetchMarvelCharacters(marvelCharacterRequest:CharacterRequest) {
        Repository().getCharacterList(request:marvelCharacterRequest) { apiResponse,error  in
            DispatchQueue.main.async {
                if error != ErrorMessage.noError {
                    self.delegate?.didFailWithError(msg:error ?? "")
                }
                else if let response = apiResponse {
                    if response.data.results.count > 30 {
                        response.data.results.removeSubrange(..<(response.data.results.count - 30))
                    }
                    self.delegate?.didReceiveResponse(dataResponse:response.data.results)
                }
            }
        }
    }
}
