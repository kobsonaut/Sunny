//
//  AppContext.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

final class AppContext {

    lazy var weatherVC: WeatherViewController = {
        let weatherService = WeatherService(
                             locationService: locationService,
                             httpClient: client)
        let dataSource = UpdatableWeatherArrayDataSource(
            cellIdentifier: WeatherViewCell.reuseID,
            elements: [],
            dataProvider: weatherService,
            configureCellBlock: { (cell, item) in
                guard let cell = cell as? WeatherViewCell else {
                    return
                }
                cell.update(with: item)
        })
        return WeatherViewController(dataSource: dataSource, weatherService: weatherService)
    }()

    static func weatherDetailVC(items: [WeatherDetailRowItem]) -> WeatherDetailViewController {
        let dataSource = ArrayDataSource<WeatherDetailRowItem>(cellIdentifier: WeatherDetailViewCell.reuseID,
                                                               elements: items,
                                                               configureCellBlock: { (cell, item) in
                                                                guard let cell = cell as? WeatherDetailViewCell else {
                                                                    return
                                                                }
                                                                cell.update(with: item)
        })
        return WeatherDetailViewController(dataSource: dataSource)
    }

    private lazy var client = HTTPClient()
    private lazy var locationService = LocationService()
}
