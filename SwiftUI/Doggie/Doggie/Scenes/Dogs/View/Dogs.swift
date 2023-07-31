//
//  Dogs.swift
//  Doggie
//
//  Created by Jose Galindo Martinez on 6/16/23.
//

import SwiftUI

struct Dogs: View {
    
    @ObservedObject var viewModel: BreedsViewModel = BreedsViewModel(service: DogServices())
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dogBreeds) { section in
                    DogCell(dogData: section)
                }
            }
            .navigationTitle("Breeds")
            .listStyle(PlainListStyle())
        }.onAppear(perform: {
            viewModel.getBreeds()
        })
    }
}

struct Dogs_Previews: PreviewProvider {
    static var previews: some View {
        Dogs()
    }
}
