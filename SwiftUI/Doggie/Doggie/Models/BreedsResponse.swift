//
//  BreedResponse.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import Foundation

struct BreedsResponse: Decodable {
    let breeds: [Breed]
    let id: String
    let url: String?
    let width: Int?
    let height: Int?
}
