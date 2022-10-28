//
//  PokemonListViewModel.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 26.10.22.
//
import UIKit
import RealmSwift

protocol PokemonListViewModelDelegate: AnyObject {
    func updateUI()
    func showPokemonInformation(pokemon: Pokemon)
}

protocol PokemonListViewModelProtocol {
    var model: [PokemonListItem] { get }
    var networkManager: NetworkManagerProtocol { get }
    func pokemonDidSelect(id: Int)
    func getNumberOfPokemonsInBD() -> Int?
    func getPokemonsName(id: Int) -> String?
}

final class PokemonListViewModel: PokemonListViewModelProtocol {
    
    private (set) var model = [PokemonListItem]()
    weak var delegate: PokemonListViewModelDelegate?
    let networkManager: NetworkManagerProtocol
    
    private let localRealm = try! Realm()
    private var pokemonArray: Results<PokemonRealmModel>!
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.getPokemons()
    }
    
    private func getPokemons() {
        networkManager.getPokemons() { [weak self] pockemonsList in
            self?.model = pockemonsList
            self?.delegate?.updateUI()
        }
    }
    
    func getNumberOfPokemonsInBD() -> Int? {
        pokemonArray = localRealm.objects(PokemonRealmModel.self).sorted(byKeyPath: "id")
        return pokemonArray.count
    }
    
    func getPokemonsName(id: Int) -> String? {
        pokemonArray = localRealm.objects(PokemonRealmModel.self).sorted(byKeyPath: "id")
        return pokemonArray.filter { $0.id == id }.first?.name
    }
    
    func pokemonDidSelect(id: Int) {
        networkManager.getPokemon(id: id) { [weak self] pokemon in
            let pokemonModel = PokemonRealmModel()
            pokemonModel.name = pokemon.name
            pokemonModel.weight = pokemon.weight
            pokemonModel.height = pokemon.height
            pokemonModel.id = pokemon.id
            pokemonModel.types = pokemon.types.first?.type.name ?? "Pokemon"
            guard let url = URL(string: pokemon.sprites.stringURL) else { return }
            if let imageData = try? Data(contentsOf: url ) {
                pokemonModel.image = imageData
            }
            DispatchQueue.main.async {
                RealmManager.shared.savePokemon(model: pokemonModel)
                self?.delegate?.showPokemonInformation(pokemon: pokemon)
            }
        }
    }
}

