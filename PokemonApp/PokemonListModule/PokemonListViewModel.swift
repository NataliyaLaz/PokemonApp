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
    func showPokemonInformation(id: Int)
    func showAlert(error:Error)
}

protocol PokemonListViewModelProtocol {
    var model: [PokemonListItem] { get }
    var networkManager: NetworkManagerProtocol? { get }
    func pokemonDidSelect(id: Int)
    func pokemonWasSelected(id: Int)
    func getNumberOfPokemonsInBD() -> Int?
    func getPokemonsName(id: Int) -> String?
}

final class PokemonListViewModel: PokemonListViewModelProtocol {
    private (set) var model = [PokemonListItem]()
    weak var delegate: PokemonListViewModelDelegate?
    let networkManager: NetworkManagerProtocol?
    
    private let localRealm = try! Realm()
    private var pokemonArray: Results<PokemonRealmModel>!
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.getPokemons()
    }
    
    func getNumberOfPokemonsInBD() -> Int? {
        pokemonArray = localRealm.objects(PokemonRealmModel.self).sorted(byKeyPath: Constants.idKeyPath)
        return pokemonArray.count
    }
    
    func getPokemonsName(id: Int) -> String? {
        pokemonArray = localRealm.objects(PokemonRealmModel.self).sorted(byKeyPath: Constants.idKeyPath)
        return pokemonArray.filter { $0.id == id }.first?.name
    }
    
    func pokemonDidSelect(id: Int) {
        pokemonArray = localRealm.objects(PokemonRealmModel.self)
        if !pokemonArray.contains(where: { $0.id == id }) {
            networkManager?.getPokemon(id: id) { [weak self] result in
                switch result {
                case .success(let pokemon):
                    let pokemonModel = PokemonRealmModel()
                    pokemonModel.name = pokemon.name
                    pokemonModel.weight = pokemon.weight
                    pokemonModel.height = pokemon.height
                    pokemonModel.id = pokemon.id
                    pokemonModel.types = pokemon.types.first?.type.name ?? Constants.defaultName
                    guard let url = URL(string: pokemon.sprites.stringURL) else { return }
                    if let imageData = try? Data(contentsOf: url ) {
                        pokemonModel.image = imageData
                    }
                    DispatchQueue.main.async {
                        RealmManager.shared.savePokemon(model: pokemonModel)
                        self?.delegate?.showPokemonInformation(pokemon: pokemon)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.delegate?.showAlert(error: error)
                    }
                }
            }
        } else {
            networkManager?.getPokemon(id: id) { [weak self] result in
                switch result {
                case .success(let pokemon):
                    DispatchQueue.main.async {
                        self?.delegate?.showPokemonInformation(pokemon: pokemon)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.delegate?.showAlert(error: error)
                    }
                }
            }
        }
    }
    
    func pokemonWasSelected(id: Int) {
        DispatchQueue.main.async {
            self.delegate?.showPokemonInformation(id: id)
        }
    }
}

// MARK: - Private extension
private extension PokemonListViewModel {
    func getPokemons() {
        networkManager?.getPokemons() { [weak self] result in
            switch result {
            case .success(let pokemonList):
                DispatchQueue.main.async {
                    self?.model = pokemonList
                    self?.delegate?.updateUI()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.showAlert(error: error)
                }
            }
        }
    }
}


