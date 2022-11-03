//
//  ViewController.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 24.10.22.
//

import UIKit
import Swinject

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
    
    private let idPokemonListTableViewCell = Constants.cellId

    var viewModel: PokemonListViewModelProtocol?
    
    init(viewModel: PokemonListViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryTeal
        title = Constants.listVCTitle
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
            let name = viewModel?.getPokemonsName(id: indexPath.row) ?? Constants.defaultName
            cell.cellConfigure(with: name)
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightForARow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = viewModel?.model {
            viewModel?.pokemonDidSelect(id: model[indexPath.item].id)
        } else {
            viewModel?.pokemonWasSelected(id: indexPath.row + 1)
        }
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
        DispatchQueue.main.async {
            guard let pokemonVC = Container.sharedContainer.resolve(PokemonViewController.self, name: Constants.pokemonVCNameModel, argument: pokemon) else { return }
            self.navigationController?.pushViewController(pokemonVC, animated: true)
        }
    }
    
    func showPokemonInformation(id: Int) {
        DispatchQueue.main.async {
            guard let pokemonVC = Container.sharedContainer.resolve(PokemonViewController.self, name: Constants.pokemonVCNameId, argument: id) else { return }
            self.navigationController?.pushViewController(pokemonVC, animated: true)
        }
    }
    
    func showAlert(error: Error) {
        let message = error.localizedDescription
        self.alertOK(title: Constants.alertErrorTitle, message: message)
    }
}

