//
//  MockedRequest.swift
//  RickAndMortyTests
//
//  Created by Atta ElAshmawy, Vodafone on 17/10/2024.
//

@testable import RickAndMorty

struct MockedCharactersRequest: RequestProtocol {

    var endPoint: String {
            return "CharacterList"
    }
    var baseURL: String { "" }
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { nil }
    var parameters: Parameters? { nil }
}
