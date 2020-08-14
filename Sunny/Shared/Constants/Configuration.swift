//
//  Configuration.swift
//  Sunny
//
//  Created by Kobsonauta on 14/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import Foundation

class Configuration {
    enum Server {
        static let baseURL = "http://api.openweathermap.org/data/2.5/weather"
        static let appId = "4e41c354247b9bff4a9fa26f51307ec7"
    }

    enum Settings {
        static let useCelciusUnits = "metric"
    }
}
