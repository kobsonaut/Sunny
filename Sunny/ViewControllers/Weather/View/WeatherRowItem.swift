//
//  WeatherRowItem.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

struct WeatherRowItem {
    let title: String
    let temperature: String
    let humidity: String
    let pressure: String
    let minTemp: String
    let maxTemp: String

    var rowWeatherDetailItems: [WeatherDetailRowItem] {
        return [
            WeatherDetailRowItem(title: LanguageManager.shared.localizedString(forKey: "lang_detail_temperature"), value: temperature),
            WeatherDetailRowItem(title:LanguageManager.shared.localizedString(forKey: "lang_detail_humidity"), value: humidity),
            WeatherDetailRowItem(title: LanguageManager.shared.localizedString(forKey: "lang_detail_pressure"), value: pressure),
            WeatherDetailRowItem(title: LanguageManager.shared.localizedString(forKey: "lang_detail_min_temp"), value: minTemp),
            WeatherDetailRowItem(title: LanguageManager.shared.localizedString(forKey: "lang_detail_max_temp"), value: maxTemp)
        ]
    }

    var currentLocationName: String {
        return "➤ " + title
    }
}
