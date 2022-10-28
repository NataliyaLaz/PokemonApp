//
//  RealmManager.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 28.10.22.
//
import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    func savePokemon(model: PokemonRealmModel) {
        try! localRealm.write{
            localRealm.add(model)
        }
    }
}
