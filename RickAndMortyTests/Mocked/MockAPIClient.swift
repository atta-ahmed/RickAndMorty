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

/*
class MockedAPIClient: APIClientProtocol {
    var returnError = false
    var jsonFileName: String?

    func request<T>(request: RequestProtocol, completion: @escaping (Result<T?, NetworkError>) -> ()) where T : Decodable, T : Encodable {
        // Simulate an error scenario if returnError is set
        if returnError {
            completion(.failure(.unknown("MockedAPIClient error test")))
            return
        }
        
        // Load the appropriate JSON file (endpoint name or custom file name)
        let fileName = jsonFileName ?? request.endPoint
        guard let response = loadJson(filename: fileName) else {
            completion(.failure(.noData))
            return
        }

        do {
            // Decode the JSON data into the expected model type
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: response)
            completion(.success(jsonData))
        } catch {
            completion(.failure(.unknown("Failed to decode JSON for \(fileName): \(error)")))
        }
    }

    // Helper to load JSON file from the test bundle
    func loadJson(filename: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        if let url = testBundle.url(forResource: filename, withExtension: "json") {
            do {
                return try Data(contentsOf: url)
            } catch {
                print("Failed to load JSON file: \(error)")
            }
        }
        return nil
    }
}
**/
