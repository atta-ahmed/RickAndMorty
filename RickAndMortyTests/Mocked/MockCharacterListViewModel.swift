//
//  MockedViewModel.swift
//  RickAndMortyTests
//
//  Created by Atta ElAshmawy on 17/10/2024.
//

@testable import RickAndMorty

class MockCharacterListViewModel: CharacterListViewModelProtocol {
    
    var countOfCharcters: Int = 0
    var isFiltering: Bool = false
    var didFetchCharacters = false
    var didFilterCharacters = false
    
    var onReciveCharacter: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    
    func character(at index: Int) -> Character? {
        return Character(id: 1, name: "Rick Sanchez", status: .alive)
    }

    func fetchCharacters() {
        didFetchCharacters = true
        onReciveCharacter?()
    }
    
    func filterCharacter(by status: CharacterStatus?, completion: @escaping () -> Void) {
        didFilterCharacters = true
        completion()
    }
    
    func simulateFetchingCharacters() {
        countOfCharcters = 1
        onReciveCharacter?()
    }

}
