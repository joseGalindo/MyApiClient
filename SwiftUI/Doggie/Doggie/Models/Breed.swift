//
//  Breed.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import Foundation

struct Breed: Codable, Identifiable {
    let id: Int
    let name: String
    let bredFor: String?
    let breedGroup: String?
    let lifeSpan: String?
    let temperament: String?
    let origin: String?
    let referenceImageId: String?
    let weight: Weight?
    let height: Height?
    let image: Image?
}

struct Weight: Codable {
    let imperial: String
    let metric: String
}

struct Height: Codable {
    let imperial: String
    let metric: String
}

struct Image: Codable {
    let id: String
    let width: Int
    let height: Int
    let url: String
}
