//
//  File.swift
//  
//
//  Created by Jose Galindo Martinez on 5/23/23.
//

import Foundation
import Combine

final public class ApiClient {
    typealias Parameters = [String: String]
    
    private let baseURL: URL
    private let apiKeyProvider: ApiKeyProvider?
    private var decoder : JSONDecoder!
    
    init?(baseURLString: String, keyProvider: ApiKeyProvider? = nil) {
        guard let url = URL(string: baseURLString) else {
            return nil
        }
        self.baseURL = url
        self.apiKeyProvider = keyProvider
        self.decoder = JSONDecoder()
    }
    
    func Get<S: Decodable>(endpoint: Endpoint,
                           parameters: Parameters = [:]) -> AnyPublisher<Result<S, APIError>, Never> {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        if !parameters.isEmpty {
            components.queryItems = parameters.compactMap {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = HttpMethod.get.rawValue
        return URLSession.shared.dataTaskPublisher(for: request)
            .map({ $0.data})
            .print()
            .decode(type: S.self, decoder: decoder)
            .map({ Result.success($0) })
            .catch({ error -> AnyPublisher<Result<S, APIError>, Never> in
                return Just(Result.failure(APIError.jsonDecodingError(error: error))).eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
    
    func Post<S: Decodable, E: Encodable>(endpoint: Endpoint,
                           parameter: E) -> AnyPublisher<Result<S, APIError>, Never> {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        guard let httpBody = try? JSONEncoder().encode(parameter) else {
            return Just(Result.failure(APIError.invalidRequest)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: queryURL)
        request.httpMethod = HttpMethod.post.rawValue
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map({ $0.data})
            .print()
            .decode(type: S.self, decoder: decoder)
            .map({ Result.success($0) })
            .catch({ error -> AnyPublisher<Result<S, APIError>, Never> in
                return Just(Result.failure(APIError.jsonDecodingError(error: error))).eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
}

internal enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum Endpoint {
    // for Dogs
    case breeds
    
    // for Rick
    case characters
    case characterDetail(charId: Int)
        
    func path() -> String {
        switch self {
        case .breeds:
            return "/breeds"
        case .characters:
            return "character"
        case let .characterDetail(charId):
            return "/character/\(charId)"
        }
    }
}

public enum APIError: Error {
    case noResponse
    case invalidRequest
    case jsonDecodingError(error: Error)
    case networkError(error: Error)
}


