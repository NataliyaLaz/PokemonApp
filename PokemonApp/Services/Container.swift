//
//  Container.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 3.11.22.
//

import UIKit
import Swinject

extension Container {
    static let sharedContainer: Container = {
        let container = Container()
        
        container.register(NetworkManagerProtocol.self) { _ in
            return NetworkManager()
        }

        container.register(PokemonListViewController.self) { PokemonListViewController(viewModel: $0.resolve(PokemonListViewModelProtocol.self)!) }
            .implements(PokemonListViewModelDelegate.self)

        container.register(PokemonListViewModelProtocol.self) { resolver in
            let viewModel = PokemonListViewModel(networkManager: resolver.resolve(NetworkManagerProtocol.self)!)
            return viewModel
        }
            .initCompleted { ($1 as! PokemonListViewModel).delegate = $0.resolve(PokemonListViewModelDelegate.self)}

        container.register(PokemonViewModelProtocol.self, name: Constants.pokemonViewModelName) { (resolver, model: Pokemon) in
            PokemonViewModel(model: model, networkManager: resolver.resolve(NetworkManagerProtocol.self)!, id: nil)
        }
        
        container.register(PokemonViewController.self, name: Constants.pokemonVCNameModel) { (resolver, model: Pokemon) in
            let vc = PokemonViewController(viewModel: resolver.resolve(PokemonViewModelProtocol.self, name: Constants.pokemonViewModelName, argument: model))
            return vc
        }
        
        container.register(PokemonViewModelProtocol.self, name: Constants.pokemonViewModelNameId) { (resolver, number: Int) in
            PokemonViewModel(model: nil, networkManager: resolver.resolve(NetworkManagerProtocol.self)!, id: number)
        }
        
        container.register(PokemonViewController.self, name: Constants.pokemonVCNameId) { (resolver, number: Int) in
            let vc = PokemonViewController(viewModel: resolver.resolve(PokemonViewModelProtocol.self, name: Constants.pokemonViewModelNameId, argument: number))
            return vc
        }
        
        return container
    }()
}

