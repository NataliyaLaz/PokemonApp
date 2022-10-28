//
//  ViewController.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 24.10.22.
//

import UIKit


final class PokemonListViewController: UIViewController {
    
    private let pokemonListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delaysContentTouches = false
        return tableView
    }()
    
    private let idPokemonListTableViewCell = "idPokemonListTableViewCell"
    
    var viewModel: PokemonListViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryTeal
        title = "Pokemon List"
        setupViews()
        setConstraints()
        setDelegates()
        setupNavigationBar()
        pokemonListTableView.register(PokemonListTableViewCell.self, forCellReuseIdentifier: idPokemonListTableViewCell)
    }
}

// MARK: - Private extension
private extension PokemonListViewController {
    
    func setupViews() {
        view.addSubview(pokemonListTableView)
    }
    
    func setDelegates() {
        pokemonListTableView.delegate = self
        pokemonListTableView.dataSource = self
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            pokemonListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pokemonListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pokemonListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.textColor]
        navBarAppearance.backgroundColor = .primaryTeal
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        let backButton = UIBarButtonItem()
        backButton.tintColor = .textColor
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}

// MARK: - UITableViewDataSource
extension PokemonListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model.count ?? (viewModel?.getNumberOfPokemonsInBD() ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idPokemonListTableViewCell, for: indexPath) as? PokemonListTableViewCell else { return UITableViewCell() }
        if let item = viewModel?.model[indexPath.row].name {
            cell.cellConfigure(with: item)
        } else {
            let name = viewModel?.getPokemonsName(id: indexPath.row) ?? "Pokemon"
            cell.cellConfigure(with: name)
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PokemonListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.pokemonDidSelect(id: viewModel?.model[indexPath.item].id ?? (indexPath.row + 1))
        print(indexPath.row + 1)
        print(viewModel?.model[indexPath.item].name)
        print(viewModel?.model[indexPath.item].id)
    }
}

// MARK: - PokemonListViewModelDelegate
extension PokemonListViewController: PokemonListViewModelDelegate {
    
    func updateUI() {
        DispatchQueue.main.async {
            self.pokemonListTableView.reloadData()
        }
    }
    
    func showPokemonInformation(pokemon: Pokemon) {
        if let networkManager = viewModel?.networkManager {
            let viewModel = PokemonViewModel(model: pokemon, networkManager: networkManager)
            DispatchQueue.main.async {
                let pokemonVC = PokemonViewController()
                pokemonVC.viewModel = viewModel
                self.navigationController?.pushViewController(pokemonVC, animated: true)
            }
        }
    }
}

