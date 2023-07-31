//
//  File.swift
//  
//
//  Created by Jose Galindo Martinez on 5/23/23.
//

import Foundation
import Combine

final public class ApiClient {
    public typealias Parameters = [String: String]
    
    private let baseURL: URL
    private let apiKeyProvider: ApiKeyProvider?
    private var decoder: JSONDecoder!
    
    public init?(baseURLString: String,
                 keyProvider: ApiKeyProvider? = nil,
                 decoderStrategy: JSONDecoder.KeyDecodingStrategy? = nil) {
        guard let url = URL(string: baseURLString) else {
            return nil
        }
        self.baseURL = url
        self.apiKeyProvider = keyProvider
        self.decoder = JSONDecoder()
        if let strategy = decoderStrategy { decoder.keyDecodingStrategy = strategy }
    }
    
    public func Get<S: Decodable>(endpoint: Endpoint,
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
        if let provider = apiKeyProvider {
            request.addValue(provider.apiKey, forHTTPHeaderField: "x-api-key")
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .map({ (data: Data, response: URLResponse) -> Data in
                // print("RESPONSE DATA: \(String(describing: String(data: data, encoding: .utf8)))")
                return data
            })
            .decode(type: S.self, decoder: decoder)
            .map({ Result.success($0) })
            .catch({ error -> AnyPublisher<Result<S, APIError>, Never> in
                return Just(Result.failure(APIError.jsonDecodingError(error: error))).eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
    
    public func Post<S: Decodable, E: Encodable>(endpoint: Endpoint,
                           parameter: E) -> AnyPublisher<Result<S, APIError>, Never> {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        guard let httpBody = try? JSONEncoder().encode(parameter) else {
            return Just(Result.failure(APIError.invalidRequest)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: queryURL)
        request.httpMethod = HttpMethod.post.rawValue
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let provider = apiKeyProvider {
            request.addValue(provider.apiKey, forHTTPHeaderField: "x-api-key")
        }
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
    case breedPhotos
        
    func path() -> String {
        switch self {
        case .breeds:
            return "/breeds"
        case .breedPhotos:
            return "/images/search"
        }
    }
}

public enum APIError: Error {
    case noResponse
    case invalidRequest
    case jsonDecodingError(error: Error)
    case networkError(error: Error)
}


