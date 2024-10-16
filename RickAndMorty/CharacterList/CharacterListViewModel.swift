//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 15/10/2024.
//

import Foundation

protocol CharacterListViewModelProtocol {
    
    var countOfCharcters: Int { get }
    var isFiltering: Bool { get }
    
    func character(at index: Int) -> Character?
    func fetchCharacters()
    
    var onReciveCharacter:  (()-> Void)? { get set }
    var onError: ((NetworkError)-> Void)? { get set }
    
    func filterCharacter(by status: CharacterStatus?, completion: @escaping () -> Void)
}

class CharacterListViewModel: CharacterListViewModelProtocol {
    private var charactersList: [Character]? = []
    private var originalCharactersList: [Character]? = []

    var onReciveCharacter: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    var isFiltering: Bool = false

    private var pageNumber = 1
    
    
    var countOfCharcters: Int {
        return charactersList?.count ?? 0
    }

    func character(at index: Int) -> Character? {
        guard let charactersList = charactersList, index >= 0, index < charactersList.count else {
            return nil
        }
        return charactersList[index]
    }
    
    func fetchCharacters() {
        // Don't fetch while filtering
        guard !isFiltering else { return }

        APIClient.shared.request(request: CharacterRequest.charactersList(pageNumber: "\(pageNumber)")) { (result: Result<CharacterResponse?, NetworkError>) in
            
            switch result {
            case .success(let response):
                if let newCharacters = response?.results {
                    
                    self.originalCharactersList?.append(contentsOf: newCharacters)
                    self.charactersList = self.originalCharactersList
                    self.pageNumber += 1 // Increment page for next fetch
                    self.onReciveCharacter?()
                } else {
                    self.onError?(NetworkError.noData)
                }
            case .failure(let error):
                self.onError?(error)
                print("error", error)
            }
        }
    }
    
    func filterCharacter(by status: CharacterStatus?, completion: @escaping () -> Void) {
        
        print("in view model filter", status)
        // Set the flag to true if filtering
        isFiltering = status != nil
        // Reset to original list if no specific status is provided
        if let status = status {
            charactersList = originalCharactersList?.filter { character in
                character.status?.rawValue == status.rawValue
            }
        } else {
            charactersList = originalCharactersList
        }
        completion()
    }

}
