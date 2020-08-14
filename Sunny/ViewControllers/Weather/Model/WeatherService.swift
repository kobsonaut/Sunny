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
    static func getWeather(for location: CLLocation) -> GetEndpoint<WeatherResult> {
        return GetEndpoint(path: Configuration.Server.baseURL, parameters: [
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "units": Configuration.Settings.useCelciusUnits,
            "APPID": Configuration.Server.appId
        ])
    }

    static func getWeather(for city: String) -> GetEndpoint<WeatherResult> {
        return GetEndpoint(path: Configuration.Server.baseURL, parameters: [
            "q": city,
            "units": Configuration.Settings.useCelciusUnits,
            "APPID": Configuration.Server.appId
        ])
    }
}

enum WeatherServiceError: Error {
    case network(HTTPClientError)
    case localization(LocationServiceError)
}

final class WeatherService: ArrayDataProvider {
    enum Constants {
        static let storeCitiesArrayKey = "storeCitiesArray"
        static let currentLocationKey = "currentLocationKey"
    }

    private let locationService: LocationService
    private let httpClient: HTTPClient
    var items = [WeatherResult]()
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
        synchronizeData()
        sendLocationRequest()
        let cities = UserDefaults.standard.userPreferences
        for city in cities {
            requestWeatherData(for: city)
        }
    }

    func addCityWeather(for city: String) {
        requestWeatherData(for: city)
    }

    private func mapWeatherResults(weather: WeatherResult) -> [WeatherRowItem] {
        let storedArray = UserDefaults.standard.userPreferences
        if !storedArray.contains(weather.cityTitle) {
            PersistanceService.saveCityWeather(city: weather.cityTitle, forKey: Constants.storeCitiesArrayKey)
            items.append(weather)
        }

        if !items.contains(weather) {
            items.append(weather)
        }

        for (index, item) in items.enumerated() {
            if item.cityTitle == UserDefaults.standard.currentLocation {
                items.swapAt(index, 0)
            }
        }

        let mapped = items.map { $0.rowWeatherItem }
        return mapped
    }

    private func synchronizeData() {
        let storedArray = UserDefaults.standard.userPreferences
        items.forEach { (item) in
            if storedArray.contains(item.cityTitle) {
                return
            }
            let filtered = items.filter { $0 != item }
            items = filtered
        }
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
                UserDefaults.standard.currentLocation = weather.cityTitle
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
