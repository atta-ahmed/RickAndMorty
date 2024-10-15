//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 15/10/2024.
//

import Foundation

protocol CharacterListViewModelProtocol {
    
    var countOfCharcters: Int? { get }
    
    func character(at index: Int) -> Character?
    func fetchCharacters()
    
    var onReciveCharacter:  (()-> Void)? { get set }
    var onError: ((NetworkError)-> Void)? { get set }
}

class CharacterListViewModel: CharacterListViewModelProtocol {
    private var charactersList: [Character]? = []
    
    var onReciveCharacter: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    var pageNumber = 1
    
    
    var countOfCharcters: Int? {
        charactersList?.count
    }
    
    func character(at index: Int) -> Character? {
        charactersList?[index]
    }
    
    func fetchCharacters() {
        APIClient.shared.request(request: CharacterRequest.charactersList(pageNumber: "\(pageNumber)")) { (result: Result<CharacterResponse?, NetworkError>) in
            
            switch result {
            case .success(let response):
                if let newCharacters = response?.results {
                    self.charactersList?.append(contentsOf: newCharacters)
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
}
