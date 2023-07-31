//
//  DogServices.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import Foundation
import Network
import Combine

protocol DogServicesProtocol: AnyObject {
    
    func getBreeds(pageNumber: Int) -> AnyPublisher<Result<[Breed], APIError>, Never>
    func getBreedPhotos(breedId: Int) -> AnyPublisher<Result<[BreedsResponse], APIError>, Never>
}

class DogServices: DogServicesProtocol {
    
    private let apiClient = ApiClient(baseURLString: ConstantsManager.shared.getBasePath() ?? "",
                                      keyProvider: ApiProvider(),
                                      decoderStrategy: .convertFromSnakeCase)
    
    func getBreeds(pageNumber: Int) -> AnyPublisher<Result<[Breed], APIError>, Never> {
        guard let api = apiClient else {
            return Just(Result.failure(APIError.invalidRequest)).eraseToAnyPublisher()
        }
        return api.Get(endpoint: .breeds, parameters: ["limit": "20", "page": String(pageNumber)])
    }
    
    func getBreedPhotos(breedId: Int) -> AnyPublisher<Result<[BreedsResponse], APIError>, Never> {
        guard let api = apiClient else {
            return Just(Result.failure(APIError.invalidRequest)).eraseToAnyPublisher()
        }
        return api.Get(endpoint: .breedPhotos, parameters: ["limit": "10",
                                                            "breed_id": String(breedId)])
    }
}

