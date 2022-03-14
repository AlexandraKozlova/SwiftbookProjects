//
//  Extension.swift
//  Sunny
//
//  Created by Aleksandra on 04.12.2021.
//

import UIKit

extension ViewController {
    
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, complitionHandler: @escaping (String) -> Void) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["New York", "London", "Dnipro", "Madrid"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                print("Search info for \(cityName)")
                let city = cityName.split(separator: " ").joined(separator: "%20")
                complitionHandler(city)
            }
    }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(search)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
}


