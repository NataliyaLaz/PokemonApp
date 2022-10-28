//
//  PokemonModel.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 26.10.22.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let sprites: Sprites
    let height: Int
    let weight: Int
    let types: [Types]
    let id: Int
}


struct Types: Codable {
    let type: Type
}

struct Type: Codable {
    let name: String
}

struct Sprites: Codable {
    let front_shiny: String?
    
    public static let decoder: JSONDecoder = {
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




