//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 15/10/2024.
//

import Foundation

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

struct Character: Codable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: Origin?
    let location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String? // You can change this to Date if you want to handle dates
    
    // Placeholder instance with default or dummy values
    static let placeholder = Character(
        id: nil,
        name: "Unknown Character", // Placeholder name
        status: "Unknown",
        species: "Unknown Species",
        type: nil,
        gender: "Unknown",
        origin: Origin(name: "Unknown Origin", url: nil),
        location: Location(name: "Unknown Location", url: nil),
        image: "placeholder_image_url", // Placeholder image URL
        episode: nil,
        url: nil,
        created: nil
    )
}

struct Origin: Codable {
    let name: String?
    let url: String?
}

struct Location: Codable {
    let name: String?
    let url: String?
}
