//
//  WeatherResult.swift
//  Sunny
//
//  Created by Polidea on 13/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    var rowItems: [WeatherRowItem] {
        return [
            WeatherRowItem(title: NSLocalizedString("Temperature", comment: ""), value: "\(temperature) °F"),
            WeatherRowItem(title: NSLocalizedString("Humidity", comment: ""), value: "\(humidity) %"),
            WeatherRowItem(title: NSLocalizedString("Pressure", comment: ""), value: "\(pressure) hpa"),
            WeatherRowItem(title: NSLocalizedString("Min. temperature", comment: ""), value: "\(minTemp) °F"),
            WeatherRowItem(title: NSLocalizedString("Max. temperature", comment: ""), value: "\(maxTemp) °F")
        ]
    }

    private let temperature: Double
    private let humidity: Double
    private let pressure: Double
    private let minTemp: Double
    private let maxTemp: Double

    private enum MainKeys: String, CodingKey {
        case main
    }

    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "humidity"
        case pressure = "pressure"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }

    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainKeys.self)
        let container = try mainContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        temperature = try container.decode(Double.self, forKey: .temperature)
        humidity = try container.decode(Double.self, forKey: .humidity)
        pressure = try container.decode(Double.self, forKey: .pressure)
        minTemp = try container.decode(Double.self, forKey: .minTemp)
        maxTemp = try container.decode(Double.self, forKey: .maxTemp)
    }
}
