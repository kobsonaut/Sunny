//
//  WeatherRowItem.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

struct WeatherRowItems {
    private var rowItems: [WeatherRowItem]

    init() {
        self.rowItems = [WeatherRowItem]()
    }
}

extension WeatherRowItems {
    var getWeatherItems: [WeatherRowItem] {
        return rowItems
    }

    mutating func removeWeatherItem(item: WeatherRowItem) {
        self.rowItems.removeAll { $0.title == item.title }
    }

    mutating func addWeatherRowItem(_ rowItem: WeatherRowItem) {
        self.rowItems.append(rowItem)
    }

    mutating func insertWeatherLocation(_ location: WeatherRowItem) {
        self.rowItems.insert(location, at: 0)
    }

    func containsWeatherLocation(_ weather: WeatherRowItem) -> Bool {
        return !rowItems.allSatisfy { $0.title != weather.title }
    }
}

struct WeatherRowItem {
    let weather: WeatherProperty
}

extension WeatherRowItem {
    var title: String {
        return weather.title
    }

    var temperature: String {
        return "\(weather.temperature.roundedCelcius)"
    }

    var humidity: String {
        return "\(weather.humidity) %"
    }

    var pressure: String {
        return "\(weather.pressure) hpa"
    }

    var minTemp: String {
        return "\(weather.minTemp.roundedCelcius)"
    }

    var maxTemp: String {
        return "\(weather.maxTemp.roundedCelcius)"
    }

    var currentLocationName: String {
        return "➤ " + weather.title
    }

    var rowWeatherDetailItems: [WeatherDetailRowItem] {
        return [
            WeatherDetailRowItem(title: LanguageManager.shared.localizedString(forKey: "lang_detail_temperature"), value: temperature),
            WeatherDetailRowItem(title:LanguageManager.shared.localizedString(forKey: "lang_detail_humidity"), value: humidity),
            WeatherDetailRowItem(title: LanguageManager.shared.localizedString(forKey: "lang_detail_pressure"), value: pressure),
            WeatherDetailRowItem(title: LanguageManager.shared.localizedString(forKey: "lang_detail_min_temp"), value: minTemp),
            WeatherDetailRowItem(title: LanguageManager.shared.localizedString(forKey: "lang_detail_max_temp"), value: maxTemp)
        ]
    }
}
