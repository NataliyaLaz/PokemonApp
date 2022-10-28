//
//  SimpleAlert.swift
//  PokemonApp
//
//  Created by Nataliya Lazouskaya on 28.10.22.
//

import UIKit

extension UIViewController {
    func alertOK(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: Constants.alertButtonTitle, style: .default)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
}
