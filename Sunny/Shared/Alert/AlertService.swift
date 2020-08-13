//
//  AlertService.swift
//  Sunny
//
//  Created by Kobsonauta on 12/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import UIKit

struct AlertService {
    func createLocationAlert(completion: @escaping (String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Add Weather Forecast", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Enter City Name"}
        let action = UIAlertAction(title: "Save", style: .default) { _ in
            let cityName = alert.textFields?.first?.text ?? ""
            completion(cityName)
        }
        alert.addAction(action)
        return alert
    }
}
