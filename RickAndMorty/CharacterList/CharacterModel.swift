//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 15/10/2024.
//

import Foundation

struct CharacterResponse: Codable {
    let info: Info?
    let results: [Character]
}

struct Info: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

enum CharacterStatus: String, Codable, CaseIterable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

struct Character: Codable {
    let id: Int?
    let name: String?
    let status: CharacterStatus?
    let species: String?
    let type: String?
    let gender: String?
    let origin: Origin?
    let location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
    
    init(
        id: Int? = nil,
        name: String? = nil,
        status: CharacterStatus? = nil,
        species: String? = nil,
        type: String? = nil,
        gender: String? = nil,
        origin: Origin? = nil,
        location: Location? = nil,
        image: String? = nil,
        episode: [String]? = nil,
        url: String? = nil,
        created: String? = nil
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
}

struct Origin: Codable {
    let name: String?
    let url: String?
}

struct Location: Codable {
    let name: String?
    let url: String?
}
