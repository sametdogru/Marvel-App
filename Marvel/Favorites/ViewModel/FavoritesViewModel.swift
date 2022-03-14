
//
//  FavoritesViewModel.swift
//  Marvel
//
//  Created by Samet Doğru on 14.02.2022.
//

import Foundation

class FavoritesViewModel {

    var updateUI : ()->() = {}
    var updateUIWithError : (_ error : String)->() = { error in}

    var favoritedCharacters : [CharacterModel] = []{
        didSet {
            updateUI()
        }
    }

    func numberOfSection() -> Int { 1 }

    func getItemsCount()->Int {

        return favoritedCharacters.count
    }

    func getItemAtIndex(_ index : Int)->CharacterModel{

        return favoritedCharacters[index]
    }

    func getFavoritedGames() {
        if let data = UserDefaults.standard.data(forKey: "favorited") {
            do {
                let decoder = JSONDecoder()
                let favoritedData = try decoder.decode([CharacterModel].self, from: data)
                self.favoritedCharacters = favoritedData
            } catch {
                updateUIWithError("Bir hata oluştu.")
            }
        }
    }
}
