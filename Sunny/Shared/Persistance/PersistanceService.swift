//
//  PersistanceService.swift
//  Sunny
//
//  Created by Kobsonauta on 13/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import Foundation

extension UserDefaults {
    var userPreferences: [String] {
        get {
            if let preferences = UserDefaults.standard.object(forKey: WeatherService.Constants.storeCitiesArrayKey) as? [String] {
                return preferences
            } else {
                return []
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: WeatherService.Constants.storeCitiesArrayKey)
        }
    }
}

class PersistanceService {
    static func saveCityWeather(city: String, forKey key: String) {
        var storedArray = loadUserPreferences(forKey: key)
        if !storedArray.contains(city) {
            storedArray.append(city)
            UserDefaults.standard.userPreferences = storedArray
        }
    }

    static func loadUserPreferences(forKey key: String) -> [String] {
        return UserDefaults.standard.object(forKey: key) as? [String] ?? [String]()
    }
}
