//
//  AlertService.swift
//  Sunny
//
//  Created by Kobsonauta on 14/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import UIKit

struct AlertService {
    func createLocationAlert(completion: @escaping (String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: LanguageManager.shared.localizedString(forKey: "lang_add_weather_alert_title"), message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = LanguageManager.shared.localizedString(forKey: "lang_add_weather_alert_placeholder")}
        let action = UIAlertAction(title: LanguageManager.shared.localizedString(forKey: "lang_add_weather_alert_button"), style: .default) { _ in
            let cityName = alert.textFields?.first?.text ?? ""
            completion(cityName)
        }
        alert.addAction(action)
        return alert
    }
}
