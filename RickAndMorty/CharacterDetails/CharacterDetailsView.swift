//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 17/10/2024.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct CharacterDetailView: View {
    var character: Character
    @Environment(\.presentationMode) var presentationMode // To handle back button action

    var body: some View {
        ZStack {
            VStack {
                if let imageURL = character.image {
                    AsyncImage(url: URL(string: character.image ?? "")) { image in
                        image
                            .resizable()
                            .cornerRadius(25)
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.height * 0.45)
                            .edgesIgnoringSafeArea(.top)
                    } placeholder: {
                        ProgressView()
                            .frame(height: UIScreen.main.bounds.height * 0.45)
                            .cornerRadius(25)
                    }
                }

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(character.name ?? "unknown")")
                            .font(.title)
                            .bold()
                        
                        Text("\(character.species ?? "unknown") • ")
                            .font(.title2)
                            .bold()
                        + Text("\(character.gender ?? "unknown")")
                            .font(.title2)
                            .foregroundColor(.gray)

                        Text("Location: \(character.location?.name ?? "unknown")")
                            .font(.headline)
                            .padding(.top, 4)
                    }
                    Spacer()

                    // Status view aligned on the right
                    VStack {
                        Text("\(character.status?.rawValue ?? "unknown")")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding([.leading, .trailing], 16)
                Spacer()
            }

            // Custom back button floating over the image
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.leading)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}
