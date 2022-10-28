//
//  SceneDelegate.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 24.10.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navVC = UINavigationController()

        let listVC = PokemonListViewController()
        let viewModel = PokemonListViewModel(networkManager: NetworkManager())
        viewModel.delegate = listVC
        listVC.viewModel = viewModel
        
        navVC.viewControllers = [listVC]
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
    }
}

