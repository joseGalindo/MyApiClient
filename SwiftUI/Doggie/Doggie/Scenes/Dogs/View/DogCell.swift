//
//  DogCell.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import SwiftUI

struct DogCell: View {
    
    @Binding var dogData: Breed?
    
    var body: some View {
        VStack {
            SwiftUI.Image("placeholder")
                .padding(-20)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.lightGray), lineWidth: 1))
            Spacer().frame(height: 40, alignment: .leading)
            Text(dogData?.name ?? "").font(.system(size: 25))
            Spacer().frame(height: 20, alignment: .leading)
        }
        .padding([.leading, .trailing, .top], 20)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.black), lineWidth: 1))
    }
}


struct DogCell_Previews: PreviewProvider {
    static var previews: some View {
        DogCell(dogData: Breed(id: 0, name: "Chihuahua", bredFor: nil, breedGroup: nil, lifeSpan: nil, temperament: nil, origin: nil, referenceImageId: nil, weight: nil, height: nil, image: nil))
    }
}
