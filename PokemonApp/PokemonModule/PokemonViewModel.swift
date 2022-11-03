//
//  PokemonViewModel.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 27.10.22.
//

import UIKit
import RealmSwift

protocol PokemonViewModelProtocol {
    var model: Pokemon? { get }
    func getPictureFrom(urlString: String, completion: @escaping (Result<UIImage, Error>) -> ())
    func getPictureFromDB() -> Data?
    func getDataFromDB()
    var pokemonModel: PokemonRealmModel { get }
}

final class PokemonViewModel: PokemonViewModelProtocol {
    
    private(set) var model: Pokemon?
    private let networkManager: NetworkManagerProtocol
    private let localRealm = try! Realm()
    
    private var pokemonArray: Results<PokemonRealmModel>!
    var pokemonModel = PokemonRealmModel()
    private var id: Int?
    
    init(model: Pokemon?, networkManager: NetworkManagerProtocol, id: Int?) {
        self.model = model
        self.networkManager = networkManager
        self.id = id
    }
    
    func getDataFromDB() {
        pokemonArray = localRealm.objects(PokemonRealmModel.self)
        pokemonModel = pokemonArray[(id ?? 0) - 1]
    }
    
    func getPictureFrom(urlString: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        networkManager.getImageUsingURL(urlString, completion: completion)
    }
    
    func getPictureFromDB() -> Data? {
        pokemonArray = localRealm.objects(PokemonRealmModel.self)
        return pokemonArray[(id ?? 0) - 1].image
    }
}
