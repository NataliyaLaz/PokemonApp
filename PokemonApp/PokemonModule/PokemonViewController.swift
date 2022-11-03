//
//  PokemonViewController.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 27.10.22.
//

import UIKit

final class PokemonViewController: UIViewController {
    private var pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .textColor
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .primaryOrange
        imageView.layer.borderWidth = Constants.borderWidth
        imageView.layer.borderColor = UIColor.borderColor.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let typeLabel = DetailLabel()
    private let weightLabel = DetailLabel()
    private let heightLabel = DetailLabel()
    
    private var labelsStackView = UIStackView()
    private var stackView = UIStackView()
    
    var viewModel: PokemonViewModelProtocol?
    
    init(viewModel: PokemonViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(viewModel?.model?.name.capitalized ?? Constants.pokemonVCTitle)"
        setupViews()
        setConstraints()
    }
    
    private var typesString: String {
        var text = ""
        if let types = viewModel?.model?.types {
            for type in types {
                if !text.isEmpty {
                    text += ", "
                }
                text += type.type.name
            }
        }
        return text
    }
}

// MARK: - Private extension
private extension PokemonViewController {
    func setupViews() {
        view.backgroundColor = .primaryTeal
        labelsStackView = UIStackView(arrangedSubviews: [typeLabel, weightLabel, heightLabel])
        labelsStackView.axis = .vertical
        labelsStackView.distribution = .fill
        labelsStackView.alignment = .leading
        stackView = UIStackView(arrangedSubviews: [pokemonNameLabel, pokemonImageView, labelsStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = UIStackView.spacingUseSystem
        view.addSubview(stackView)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        getImage()
        
        if viewModel?.model != nil {
            pokemonNameLabel.text = viewModel?.model?.name.capitalized
            typeLabel.text = Constants.typeLabelText + typesString
            weightLabel.text = Constants.weightLabelText + "\(viewModel?.model?.weight ?? Constants.defaultWeight)" + Constants.weightMeasurementText
            heightLabel.text = Constants.heightLabelText + "\(viewModel?.model?.height ?? Constants.defaultHeight)" + Constants.weightMeasurementText
        } else {
            checkDB()
            pokemonNameLabel.text = viewModel?.pokemonModel.name.capitalized
            typeLabel.text = Constants.typeLabelText + (viewModel?.pokemonModel.types ?? Constants.defaultType)
            weightLabel.text = Constants.weightLabelText + "\(viewModel?.pokemonModel.weight ?? Constants.defaultWeight)" + Constants.weightMeasurementText
            heightLabel.text = Constants.heightLabelText + "\(viewModel?.pokemonModel.height ?? Constants.defaultHeight)" + Constants.weightMeasurementText
        }
    }
    
    private func checkDB() {
        viewModel?.getDataFromDB()
    }
    
    private func getImage() {
        if viewModel?.model != nil  {
            viewModel?.getPictureFrom(urlString: viewModel?.model?.sprites.stringURL ?? "", completion: { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.pokemonImageView.image = image
                    }
                case .failure(let error):
                    let message = error.localizedDescription
                    self.alertOK(title: Constants.alertErrorTitle, message: message)
                }
            })
        } else {
            guard let imageData = viewModel?.getPictureFromDB() else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.pokemonImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            pokemonImageView.widthAnchor.constraint(equalTo: pokemonImageView.heightAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            activityIndicator.centerXAnchor.constraint(equalTo: pokemonImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: pokemonImageView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.1)
        ])
    }
}

