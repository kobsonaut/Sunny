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
    private static let weatherUnit = "imperial"

    static func getWeather(for location: CLLocation) -> GetEndpoint<WeatherResult> {
        return GetEndpoint(path: baseURL, parameters: [
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "APPID": appId
        ])
    }

    static func getWeather(for city: String) -> GetEndpoint<WeatherResult> {
        return GetEndpoint(path: baseURL, parameters: [
            "q": city,
            "units": weatherUnit,
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
    private var items = [WeatherResult]()
    typealias WeatherRowItemsObserver = (Result<[WeatherRowItem], WeatherServiceError>) -> Void

    var observer: WeatherRowItemsObserver?

    init(locationService: LocationService = LocationService(), httpClient: HTTPClient = HTTPClient()) {
        self.locationService = locationService
        self.httpClient = httpClient
    }

    func registerDataObserver(_ observer: @escaping WeatherRowItemsObserver) {
        self.observer = observer
    }

    func refreshData() {
        items.removeAll()
        sendLocationRequest()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            let cities = ["Szczecin", "Warsaw", "Berlin", "Londyn", "Paris"]
            for city in cities {
                self?.requestWeatherData(for: city)
            }
        }
    }

    func addCityWeather(for city: String) {
        requestWeatherData(for: city)
    }

    private func mapWeatherResults(weather: WeatherResult) -> [WeatherRowItem] {
        if !items.contains(weather) {
            items.append(weather)
        }
        let mapped = self.items.map { $0.rowWeatherItem }
        return mapped
    }

    private func sendLocationRequest() {
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
            switch result {
            case .success(let weather):
                guard let mapped = self?.mapWeatherResults(weather: weather) else { return }
                self?.observer?(.success(mapped))
                break
            case .error(let error):
                self?.observer?(.error(.network(error)))
                break
            }
        })
    }

    private func requestWeatherData(for city: String) {
        let endpoint = WeatherServiceEndpoints.getWeather(for: city)
        httpClient.performRequest(for: endpoint, completion: { [weak self] result in
            switch result {
            case .success(let weather):
                guard let mapped = self?.mapWeatherResults(weather: weather) else { return }
                self?.observer?(.success(mapped))
                break
            case .error(let error):
                self?.observer?(.error(.network(error)))
                break
            }
        })
    }
}
