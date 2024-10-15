//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 15/10/2024.
//

import Foundation

/// Enum of error messages
enum NetworkError: Error, LocalizedError {

    init(error: Error) {
        self = .unknown(error.localizedDescription)
    }

    // request
    case canNotMapRequest
    case canNotEncodeParameters
    case invalidURL
    case invalidRequest
    
    // response
    case canNotDecodeObject
    case noData
    
    // generics
    case generic
    case unknown(String?)

    public var localizedDescription: String {
        switch self {
            
        case .invalidURL:
            return "Invalid URL"
        case .invalidRequest:
            return "Invalid request"
        case .canNotEncodeParameters:
            return "Can not encode body parameters"
        case .canNotMapRequest:
            return "Error! can't map request"
            
        case .noData:
            return "No data founded"
        case .canNotDecodeObject:
            return "Error! can't decode object"

        case .generic:
            return "Generic error"
        case .unknown(let message):
            return message ?? "Unknown network error"

        }
    }

}
