//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 15/10/2024.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Codable>(request: RequestProtocol,
                             completion: @escaping (Result<T?, NetworkError>) -> ())
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    private init() {}

    func request<T: Codable>(request: RequestProtocol, completion: @escaping (Result<T?, NetworkError>) -> ()) {
        // Map request protocol to `URLRequest`
        do {
            let urlRequest = try urlRequest(from: request)
            
            print("------>", urlRequest.url)
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                // Check error
                if let error = error {
                    completion(.failure(NetworkError(error: error)))
                    return
                }

                // Check if there are response data
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }

                // Map data to encodable model
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(NetworkError.noData))
                }
            }.resume()
            
        } catch {
            completion(.failure(NetworkError.invalidRequest))
        }
    }
    
    /// Maps RequestProtocol to URLRequest
    private func urlRequest(from request: RequestProtocol) throws -> URLRequest {
        // Ensure the URL is valid
        guard let url = URL(string: request.baseURL + request.endPoint) else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        // Set headers
        request.headers?.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        // Handle parameters based on the HTTP method
        if let parameters = request.parameters {
            switch request.method {
            case .get:
                // Encode parameters into URL for GET requests
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                urlRequest.url = components?.url
                
            default:
                // Set body for non-GET requests
                do {
                    let bodyParameters = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    urlRequest.httpBody = bodyParameters
                } catch {
                    throw NetworkError.canNotEncodeParameters
                }
            }
        }

        return urlRequest
    }

}
