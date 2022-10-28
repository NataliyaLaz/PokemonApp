//
//  PokemonModel.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 26.10.22.
//

import Foundation

struct Pokemon: Codable {
    var name: String
    var sprites: Sprites
    var height: Int
    var weight: Int
    var types: [Types]
    var id: Int
}

struct Types: Codable {
    var type: Type
}

struct Type: Codable {
    var name: String
}

struct Sprites: Codable {
    var front_shiny: String?

    public static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    var stringURL: String {
        if let frontShiny = front_shiny {
            return frontShiny
        } else { return "" }
    }
}

