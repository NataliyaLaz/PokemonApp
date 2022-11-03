//
//  SceneDelegate.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 24.10.22.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

//    let container: Container = {
//        let container = Container()
//        container.register(NetworkManagerProtocol.self) { _ in
//            return NetworkManager()
//        }
//
//        container.register(PokemonListViewController.self) { PokemonListViewController(viewModel: $0.resolve(PokemonListViewModelProtocol.self)!) }
//            .implements(PokemonListViewModelDelegate.self)
//
//        container.register(PokemonListViewModelProtocol.self) { resolver in
//            let viewModel = PokemonListViewModel(networkManager: resolver.resolve(NetworkManagerProtocol.self)!)
//            return viewModel
//        }
//            .initCompleted { ($1 as! PokemonListViewModel).delegate = $0.resolve(PokemonListViewModelDelegate.self) }
//
//        return container
//    }()
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navVC = UINavigationController()
        guard let listVC = Container.sharedContainer.resolve(PokemonListViewController.self) else { return }
        
        navVC.viewControllers = [listVC]
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
    }
}

