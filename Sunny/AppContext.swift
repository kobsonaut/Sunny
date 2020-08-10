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
        let dataSource = UpdatableArrayDataSource<WeatherRowItem, WeatherServiceError>(
            cellIdentifier: WeatherViewCell.identifier,
            elements: [],
            dataProvider: WeatherService(
                locationService: locationService,
                httpClient: client
            ),
            configureCellBlock: { (cell, item) in
                guard let cell = cell as? WeatherViewCell else {
                    return
                }
                cell.update(with: item)
            }
        )

        return WeatherViewController(dataSource: dataSource)
    }()

    private lazy var client = HTTPClient()
    private lazy var locationService = LocationService()
}
