//
//  CharacterDetailsViewModel.swift
//  Marvel
//
//  Created by Samet Doğru on 14.02.2022.
//

import Foundation

protocol CharacterDetailsViewModelDelegate {
    func didReceiveCharacterDetails(dataResponse:CharacterModel?)
    func didFailWithError(msg:String)
}

struct CharacterDetailsViewModel {
    
    var delegate:CharacterDetailsViewModelDelegate?
    
    func fetchMarvelCharacterDetails(marvelCharacterRequest:CharacterRequest,characterId:Int) {
        Repository().getCharacterDetails(request:marvelCharacterRequest,characterId:characterId) { apiResponse,error in
            DispatchQueue.main.async {
                if error != ErrorMessage.noError {
                    self.delegate?.didFailWithError(msg:error ?? "")
                }
                else if let response = apiResponse {
                    self.delegate?.didReceiveCharacterDetails(dataResponse:response)
                }
            }
        }
    }
}
