//
//  PokemonModel.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 25.10.22.
//

import Foundation

struct Pokemons: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    var name: String
    var url: String = ""

    var id: Int {
        let fileName = url
        let fileArray = fileName.split(separator: "/")
        return Int(fileArray.suffix(1).first ?? "") ?? 0
    }
}
