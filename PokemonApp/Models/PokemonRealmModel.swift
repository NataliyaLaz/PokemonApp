//
//  PokemonRealmModel.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 28.10.22.
//

import Foundation
import RealmSwift

class PokemonRealmModel: Object {
    
    @Persisted var name: String = ""
    @Persisted var height: Int = 0
    @Persisted var weight: Int = 0
    @Persisted var types: String
    @Persisted var id: Int
    @Persisted var image: Data?
}

