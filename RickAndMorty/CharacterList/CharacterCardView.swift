//
//  CharacterCardView.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 15/10/2024.
//

import SwiftUI

struct CharacterCardView: View {

    var character: Character

    var body: some View {
        HStack() {
                VStack {
                    AsyncImage(url: URL(string: character.image ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(10)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .frame(width: 80, height: 80)
                .padding()
                
                VStack(alignment: .leading) {
                    Text(character.name ?? "")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(character.species ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.top, 20)
                Spacer()
            }
        .border(Color(.gray), width: 1, cornerRadius: 12)
        .background(character.status == "Alive" ? .mint : .white , cornerRadius: 12)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

}
