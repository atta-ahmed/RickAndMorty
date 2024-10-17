//
//  CharacterCardView.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 15/10/2024.
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
        .border(.borderGrayColor, width: 1, cornerRadius: 12)
        .background(backgroundColor(for: character.status) , cornerRadius: 12)
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
    
    private func backgroundColor(for status: CharacterStatus?) -> Color {
        switch status {
        case .alive:
            return .aliveBGColor
        case .dead:
            return .deadBGColor
        case .unknown:
            return .white
        case .none:
            return .white
        }
    }

}
