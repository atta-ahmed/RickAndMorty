//
//  MockAPIClient.swift
//  RickAndMortyTests
//
//  Created by Atta ElAshmawy on 17/10/2024.
//

import Foundation
@testable import RickAndMorty

class MockAPIClient: APIClientProtocol {
    var returnError = false
    var dummyData: Codable?
    
    func request<T>(request: RequestProtocol, completion: @escaping (Result<T?, NetworkError>) -> ()) where T : Decodable, T : Encodable {
        // Simulate an error scenario if returnError is set
        if returnError {
            completion(.failure(.unknown("MockedAPIClient error test")))
            return
        }
        
        // Return the injected mock data or an error
        if let dummyData = dummyData as? T {
            completion(.success(dummyData))
        } else {
            completion(.failure(.noData))
        }
    }
}
