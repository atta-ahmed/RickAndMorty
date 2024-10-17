//
//  CharacterRequest.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 15/10/2024.
//

import Foundation

enum CharacterRequest: RequestProtocol {
    
    // Specify the response type
    typealias ResponseType = CharacterResponse
    
    case charactersList(pageNumber: String)
    case characterDetails(characterId: String)
    
    var baseURL: String {
        "https://rickandmortyapi.com/api/"
    }
    
    var endPoint: String {
        switch self {
        case .charactersList(let pageNumber):
            return "character/?page=\(pageNumber)"
            
        case .characterDetails(let characterId):
            return "product/\(characterId)"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var headers: HTTPHeaders? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: Parameters? { nil }
}
