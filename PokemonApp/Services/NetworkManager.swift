//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 25.10.22.
//

import UIKit

protocol NetworkManagerProtocol {
    func getPokemons(completion: @escaping ([PokemonListItem]) -> ())
    func getPokemon(id: Int, completion: @escaping (Pokemon) -> ())
    func getImageUsingURL(_ urlString: String, completion: @escaping (UIImage?) -> ())
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let urlString = "https://pokeapi.co/api/v2/"
    private let session = URLSession.shared
    private let imageCache = NSCache<NSString, UIImage>()
    
    func getPokemons(completion: @escaping ([PokemonListItem]) -> ()) {
        guard let url = URL(string: "\(urlString)pokemon-species?limit=905") else {
            return
        }
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                do {
                     let decoder = JSONDecoder()
                     let response = try decoder.decode(Pokemons.self, from: data)
                     let pokemonsList = response.results
                     completion(pokemonsList)
                } catch {
                    print(error)
                }
            }
            
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
    
    func getPokemon(id: Int, completion: @escaping (Pokemon) -> ()) {
        
        guard let url = URL(string: "\(urlString)pokemon/\(id)") else {
            return
        }
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                do {
                     let decoder = JSONDecoder()
                     let response = try decoder.decode(Pokemon.self, from: data)
                     completion(response)
                } catch {
                    print(error)
                }
            }
            
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
    
    func getImageUsingURL(_ urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            completion(imageFromCache)
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { [weak self] data, responce, error in
            if let data = data {
                if let image = UIImage(data: data) {
                    completion(image)
                    self?.imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
            
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
}

