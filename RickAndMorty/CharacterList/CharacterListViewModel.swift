//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 15/10/2024.
//

import Foundation

protocol CharacterListViewModelProtocol {
    var countOfCharcters: Int { get }
    var isFiltering: Bool { get }
    
    func character(at index: Int) -> Character?
    func fetchCharacters()
    
    var onReciveCharacter: (() -> Void)? { get set }
    var onError: ((NetworkError) -> Void)? { get set }
    
    func filterCharacter(by status: CharacterStatus?, completion: @escaping () -> Void)
}

class CharacterListViewModel: CharacterListViewModelProtocol {
    
    private let apiClient: APIClientProtocol
    private var request: RequestProtocol
    private var charactersList: [Character] = []
    private var originalCharactersList: [Character] = []
    private var pageNumber = 1
    private var isFetching = false
    var isFiltering: Bool = false
    
    var onReciveCharacter: (() -> Void)?
    var onError: ((NetworkError) -> Void)?

    // Dependency injection through initializer
    init(apiClient: APIClientProtocol = APIClient.shared,
         request: RequestProtocol = CharacterRequest.charactersList(pageNumber: "1")) {
        self.apiClient = apiClient
        self.request = request
    }
    
    var countOfCharcters: Int {
        return charactersList.count
    }

    func character(at index: Int) -> Character? {
        guard index >= 0, index < charactersList.count else { return nil }
        return charactersList[index]
    }

    func fetchCharacters() {
        guard !isFetching, !isFiltering else { return }
        // Prevent duplicate fetches
        isFetching = true
        // Ensure fetching is reset
        defer { isFetching = false }
        
        // Update request with the current page number (if applicable)
        if var paginatedRequest = request as? CharacterRequest {
            paginatedRequest = .charactersList(pageNumber: "\(pageNumber)")
            request = paginatedRequest
        }

        apiClient.request(request: request) { [weak self] (result: Result<CharacterResponse?, NetworkError>) in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if let newCharacters = response?.results {
                    self.originalCharactersList.append(contentsOf: newCharacters)
                    self.charactersList = self.originalCharactersList
                    self.pageNumber += 1
                    self.onReciveCharacter?()
                } else {
                    self.onError?(.noData)
                }
            case .failure(let error):
                self.onError?(error)
            }
        }
    }

    func filterCharacter(by status: CharacterStatus?, completion: @escaping () -> Void) {
        isFiltering = status != nil
        if let status = status {
            charactersList = originalCharactersList.filter { $0.status == status }
        } else {
            charactersList = originalCharactersList
        }
        completion()
    }
}
