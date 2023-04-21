//
//  NetworkError.swift
//  NetworkLayerOne
//
//  Created by user on 21.04.2023.
//

enum NetworkError: Error {
    case missingUrl
    case unavailableNetwork
    case responseError
    case decodeError
    case taskError
    
    var message: String {
        switch self {
        case .missingUrl:
            return "URL is missing..."
        case .unavailableNetwork:
            return "Network is unavailable..."
        case .responseError:
            return "Bad response..."
        case .decodeError:
            return "Failed in decoding code..."
        case .taskError:
            return "Error in URLSession data task.."
        }
    }
}
