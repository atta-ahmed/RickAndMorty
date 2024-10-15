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
        HStack {
            AsyncImage(url: URL(string: character.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Fill the frame
                      .clipped() // Clip any overflow
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
            }
            .frame(height: 120) // Set the height for the image, adjust as needed

            VStack(alignment: .leading) {
                Text(character.name ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(character.species ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }

//    var body: some View {
//           VStack {
//               // Image Section
//               AsyncImage(url: URL(string: character.image)) { image in
//                   image
//                       .resizable()
//                       .aspectRatio(contentMode: .fill)
//                       .frame(height: 50)
//                       .cornerRadius(10)
//                       .overlay(
//                           Rectangle()
//                               .foregroundColor(.black.opacity(0.3))
//                               .cornerRadius(10)
//                       )
//               } placeholder: {
//                   ProgressView()
//                       .frame(height: 50)
//                       .background(Color.gray.opacity(0.2))
//                       .cornerRadius(10)
//               }
//
//               // Name Section
//               Text(character.name)
//                   .font(.title2)
//                   .fontWeight(.bold)
//                   .padding([.top, .bottom], 5)
//
//               // Additional Info Section
//               VStack(alignment: .leading) {
//                   Text("Species: \(character.species)")
//                       .font(.subheadline)
//                       .foregroundColor(.gray)
//
//                   Text("Status: \(character.status)")
//                       .font(.subheadline)
//                       .foregroundColor(character.status == "Alive" ? .green : .red)
//               }
//               .padding(.bottom, 5)
//           }
//           .padding()
//           .background(Color.white)
//           .cornerRadius(12)
//           .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
//           .padding(.horizontal)
//       }
}
