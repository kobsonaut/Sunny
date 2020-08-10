//
//  WeatherService.swift
//  Sunny
//
//  Created by Polidea on 13/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherServiceEndpoints {
    private static let baseURL = "http://api.openweathermap.org/data/2.5/weather"
    private static let appId = "4e41c354247b9bff4a9fa26f51307ec7"

    static func getWeather(for location: CLLocation) -> GetEndpoint<WeatherResult> {
        return GetEndpoint(path: baseURL, parameters: [
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "APPID": appId
            ])
    }
}

enum WeatherServiceError: Error {
    case network(HTTPClientError)
    case localization(LocationServiceError)
}

final class WeatherService: ArrayDataProvider {
    private let locationService: LocationService
    private let httpClient: HTTPClient
    typealias WeatherRowItemsObserver = (Result<[WeatherRowItem], WeatherServiceError>) -> Void

    var observer: WeatherRowItemsObserver?

    init(locationService: LocationService, httpClient: HTTPClient) {
        self.locationService = locationService
        self.httpClient = httpClient
    }

    func registerDataObserver(_ observer: @escaping WeatherRowItemsObserver) {
        self.observer = observer
    }

    func refreshData() {
        if locationService.isEnabled, let lastLocation = locationService.lastLocation {
            requestWeatherData(for: lastLocation)
        } else {
            locationService.enable(with: { [weak self] locationResult in
                switch locationResult {
                case let .error(error):
                    self?.observer?(.error(.localization(error)))
                case let .success(location):
                    self?.requestWeatherData(for: location)
                }
            })
        }
    }

    private func requestWeatherData(for location: CLLocation) {
        let endpoint = WeatherServiceEndpoints.getWeather(for: location)
        httpClient.performRequest(for: endpoint, completion: { [weak self] result in
            let mapped = result.mapBoth( { $0.rowItems }, right: { WeatherServiceError.network($0) })
            self?.observer?(mapped)
        })
    }
}
