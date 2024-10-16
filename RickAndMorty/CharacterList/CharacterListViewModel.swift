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
    
    private var charactersList: [Character] = []
    private var originalCharactersList: [Character] = []
    private var pageNumber = 1
    private var isFetching = false // Track ongoing fetch requests
    
    var isFiltering: Bool = false
    
    var onReciveCharacter: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    
    var countOfCharcters: Int {
        return charactersList.count
    }

    // Retrieve character at index
    func character(at index: Int) -> Character? {
        guard index >= 0, index < charactersList.count else {
            return nil
        }
        return charactersList[index]
    }

    // Fetch characters from API (pagination supported)
    func fetchCharacters() {
        // Avoid duplicate fetching or fetches during filtering
        guard !isFetching, !isFiltering else { return }
        
        isFetching = true // Set fetching state to true
        APIClient.shared.request(
            request: CharacterRequest.charactersList(pageNumber: "\(pageNumber)")
        ) { [weak self] (result: Result<CharacterResponse?, NetworkError>) in
            guard let self = self else { return }
            
            self.isFetching = false // Reset fetching state
            
            switch result {
            case .success(let response):
                if let newCharacters = response?.results {
                    self.originalCharactersList.append(contentsOf: newCharacters)
                    self.charactersList = self.originalCharactersList
                    self.pageNumber += 1
                    self.onReciveCharacter?()
                } else {
                    self.onError?(NetworkError.noData)
                }
            case .failure(let error):
                self.onError?(error)
                print("Error fetching characters:", error)
            }
        }
    }

    // Filter characters by status
    func filterCharacter(by status: CharacterStatus?, completion: @escaping () -> Void) {
        // Set the isFiltering flag to true if filtering
        isFiltering = status != nil
        
        if let status = status {
            charactersList = originalCharactersList.filter { character in
                character.status?.rawValue == status.rawValue
            }
        } else {
            // Reset if no filter
            charactersList = originalCharactersList
        }

        completion()
    }
}
