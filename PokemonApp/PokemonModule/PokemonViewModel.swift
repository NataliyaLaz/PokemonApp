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
    func getPictureFrom(urlString: String, completion: @escaping (UIImage?) -> ())
}

final class PokemonViewModel: PokemonViewModelProtocol {
    
    private(set) var model: Pokemon?
    private let networkManager: NetworkManagerProtocol
    
    
    init(model: Pokemon, networkManager: NetworkManagerProtocol) {
        self.model = model
        self.networkManager = networkManager
    }
    
    func getPictureFrom(urlString: String, completion: @escaping (UIImage?) -> ()) {
        networkManager.getImageUsingURL(urlString, completion: completion)
    }
}
