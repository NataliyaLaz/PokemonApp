//
//  DetailLabel.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 27.10.22.
//

import UIKit

final class DetailLabel: UILabel {

    convenience init(text: String) {
        self.init()
        configure()
    }
}

// MARK: - Private extension
private extension DetailLabel {
    private func configure() {
        self.font = UIFont.preferredFont(forTextStyle: .title2)
        self.textAlignment = .left
    }
}

