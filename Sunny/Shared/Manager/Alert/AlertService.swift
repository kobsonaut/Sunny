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

    func createCityNameAlert(error: WeatherServiceError) -> UIAlertController? {
        var title = LanguageManager.shared.localizedString(forKey: "lang_add_weather_error_alert_general_title")
        var message = LanguageManager.shared.localizedString(forKey: "lang_add_weather_error_alert_general_description")

        switch error {
        case .network(let errorType):
            switch errorType {
            case .badStatusCode(let code):
                if code == 400 {
                    return nil
                }
                
                title = LanguageManager.shared.localizedString(forKey: "lang_add_weather_network_error_alert_title")
                message = LanguageManager.shared.localizedString(forKey: "lang_add_weather_network_error_alert_description_\(code)")
                break

            default:
                break
            }

        case .localization(_):
            title = LanguageManager.shared.localizedString(forKey: "lang_add_weather_l10n_error_alert_title")
            message = LanguageManager.shared.localizedString(forKey: "lang_add_weather_l10n_error_alert_description")
            break
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: LanguageManager.shared.localizedString(forKey: "lang_add_weather_error_alert_button"), style: .default)
        alert.addAction(action)

        return alert
    }
}
