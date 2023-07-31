//
//  BreedsViewModel.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import Foundation
import Combine
import Network

final class BreedsViewModel: ObservableObject {
    
    // this should be injected
    private var service: DogServicesProtocol!
    @Published var dogBreeds: [Breed]!
    @Published var apiErrorResponse: APIError?
    private var cancellables: Set<AnyCancellable>!
    private var pageNumber: Int = 0
    
    init(service: DogServicesProtocol) {
        self.service = service
        self.cancellables = Set<AnyCancellable>()
        self.dogBreeds = [Breed]()
    }
    
    func getBreeds() {
        service.getBreeds(pageNumber: pageNumber)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let breeds):
                    if breeds.count > 0 { self?.pageNumber += 1 }
                    self?.dogBreeds?.append(contentsOf: breeds)
                case .failure(let apiError):
                    self?.apiErrorResponse = apiError
                }
                
            }.store(in: &cancellables)
    }
}
