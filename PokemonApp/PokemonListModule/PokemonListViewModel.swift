//
//  PokemonListViewModel.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 26.10.22.
//
import UIKit

protocol PokemonListViewModelDelegate: AnyObject {
    func updateUI()
    func showPokemonInformation(pokemon: Pokemon)
}

protocol PokemonListViewModelProtocol {
    var model: [PokemonListItem] { get }
    var networkManager: NetworkManagerProtocol { get }
    func pokemonDidSelect(id: Int)
}

final class PokemonListViewModel: PokemonListViewModelProtocol {

    private (set) var model = [PokemonListItem]()
    weak var delegate: PokemonListViewModelDelegate?
    let networkManager: NetworkManagerProtocol
    
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
    
    func showPokemonInformation(pokemon: Pokemon) {
        //show info
    }
    
    func pokemonDidSelect(id: Int) {
        networkManager.getPokemon(id: id) { [weak self] pokemon in
            self?.delegate?.showPokemonInformation(pokemon: pokemon)
        }
    }
    
}

