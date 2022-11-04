//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 25.10.22.
//

import UIKit

protocol NetworkManagerProtocol {
    func getPokemons(completion: @escaping (Result<[PokemonListItem], Error>) -> ())
    func getPokemon(id: Int, completion: @escaping (Result<Pokemon, Error>) -> ())
    func getImageUsingURL(_ urlString: String, completion: @escaping (Result<UIImage, Error>) -> ())
}

final class NetworkManager: NetworkManagerProtocol {
    private let urlString = Constants.urlString
    private let imageCache = NSCache<NSString, UIImage>()
    
    private func createSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        let session = URLSession(configuration: config)
        return session
    }
    
    func getPokemons(completion: @escaping (Result<[PokemonListItem], Error>) -> ()) {
        guard let url = URL(string: urlString + Constants.urlAddsString) else {
            return
        }
        let session = createSession()
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                do {
                     let decoder = JSONDecoder()
                     let response = try decoder.decode(Pokemons.self, from: data)
                     let pokemonsList = response.results
                    completion(.success(pokemonsList))
                } catch {
                    completion(.failure(error))
                }
            }
            if let error = error {
                completion(.failure(error))
            }
        })
        task.resume()
    }
    
    func getPokemon(id: Int, completion: @escaping (Result<Pokemon, Error>) -> ())  {
        guard let url = URL(string: "\(urlString)\(Constants.pokemonString)\(id)") else {
            return
        }
        let session = createSession()
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                do {
                     let decoder = JSONDecoder()
                     let response = try decoder.decode(Pokemon.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            }
            if let error = error {
                completion(.failure(error))
            }
        })
        task.resume()
    }
    
    func getImageUsingURL(_ urlString: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            completion(.success(imageFromCache))
            return
        }
        let session = createSession()
        let task = session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            if let data = data {
                if let image = UIImage(data: data) {
                    completion(.success(image))
                    self?.imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
            if let error = error {
                completion(.failure(error))
            }
        })
        task.resume()
    }
}

