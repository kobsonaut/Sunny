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
            WeatherDetailRowItem(title: NSLocalizedString("Temperature", comment: ""), value: temperature),
            WeatherDetailRowItem(title: NSLocalizedString("Humidity", comment: ""), value: humidity),
            WeatherDetailRowItem(title: NSLocalizedString("Pressure", comment: ""), value: pressure),
            WeatherDetailRowItem(title: NSLocalizedString("Min. temperature", comment: ""), value: minTemp),
            WeatherDetailRowItem(title: NSLocalizedString("Max. temperature", comment: ""), value: maxTemp)
        ]
    }
}
