//
//  WeatherResult.swift
//  Sunny
//
//  Created by Polidea on 13/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable, Equatable {
    private let temperature: Double
    private let humidity: Double
    private let pressure: Double
    private let minTemp: Double
    private let maxTemp: Double
    private let cityName: String

    private enum MainKeys: String, CodingKey {
        case main
        case cityName = "name"
    }

    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "humidity"
        case pressure = "pressure"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }

    var cityTitle: String {
        return cityName
    }

    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainKeys.self)
        let container = try mainContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        cityName = try mainContainer.decode(String.self, forKey: .cityName)
        temperature = try container.decode(Double.self, forKey: .temperature)
        humidity = try container.decode(Double.self, forKey: .humidity)
        pressure = try container.decode(Double.self, forKey: .pressure)
        minTemp = try container.decode(Double.self, forKey: .minTemp)
        maxTemp = try container.decode(Double.self, forKey: .maxTemp)
    }

    var weatherProperty: WeatherProperty {
        return WeatherProperty(title: cityName,
                               temperature: temperature,
                               humidity: humidity,
                               pressure: pressure,
                               minTemp: minTemp,
                               maxTemp: maxTemp)
    }
}
