//
//  DogDetail.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import SwiftUI

struct DogDetail: View {
    
    @Binding var selectedDog: Breed?
    
    var body: some View {
        Text("prueba")
    }
}

struct DogDetail_Previews: PreviewProvider {
    static var previews: some View {
        DogDetail(selectedDog: .constant(Breed(id: 0, name: "chihuahua", bredFor: nil, breedGroup: nil, lifeSpan: nil, temperament: nil, origin: nil, referenceImageId: nil, weight: nil, height: nil, image: nil)))
    }
}
