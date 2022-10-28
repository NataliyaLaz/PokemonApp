//
//  PokemonListTableViewCell.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 25.10.22.
//

import UIKit

final class PokemonListTableViewCell: UITableViewCell {
    private let backgroundCell: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryOrange
        view.layer.cornerRadius = Constants.cornerRadius8
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.borderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .textColor
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellConfigure(with name: String?) {
        pokemonNameLabel.text = name?.capitalized
    }
}

// MARK: - Private extension
private extension PokemonListTableViewCell {
    func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(backgroundCell)
        addSubview(pokemonNameLabel)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: Constants.inset8),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.inset8),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.inset8),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.inset8)
        ])

        NSLayoutConstraint.activate([
            pokemonNameLabel.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            pokemonNameLabel.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: Constants.inset8),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -Constants.inset8)
        ])
    }
}
