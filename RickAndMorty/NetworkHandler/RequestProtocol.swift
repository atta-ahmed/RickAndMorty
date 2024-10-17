//
//  RequestProtocol.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 14/10/2024.
//

import Foundation


typealias Parameters = [String: Any]
typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol RequestProtocol {
    var baseURL: String { get }
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
}
