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
    var weatherViewModels = WeatherRowItems()
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
        sendLocationRequest()
        let cities = UserDefaults.standard.userPreferences
        for city in cities {
            requestWeatherData(for: city)
        }
    }

    func addCityWeather(for city: String) {
        requestWeatherData(for: city)
    }

    func removeWeatherFromTheList(weather: WeatherRowItem) {
        weatherViewModels.removeWeatherItem(item: weather)
    }

    private func validateWeatherResults(weather: WeatherResult) -> [WeatherRowItem] {
        let rowItem = WeatherRowItem(weather: weather.weatherProperty)

        // Check if the list contains the weather location
        if weatherViewModels.containsWeatherLocation(rowItem) == false {
            // Set current location as the first one
            if rowItem.title == UserDefaults.standard.currentLocation {
                weatherViewModels.insertWeatherLocation(rowItem)
            } else {
                weatherViewModels.addWeatherRowItem(rowItem)
            }

            // Save user preferences
            PersistanceService.saveCityWeather(city: rowItem.title,
                                               forKey: Constants.storeCitiesArrayKey)
        }

        return weatherViewModels.getWeatherItems
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
                guard let mapped = self?.validateWeatherResults(weather: weather) else { return }
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
                guard let mapped = self?.validateWeatherResults(weather: weather) else { return }
                self?.observer?(.success(mapped))
                break
            case .error(let error):
                self?.observer?(.error(.network(error)))
                break
            }
        })
    }
}
