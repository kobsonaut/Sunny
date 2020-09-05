//
//  UpdatableWeatherArrayDataSource.swift
//  Sunny
//
//  Created by Kobsonauta on 14/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import Foundation
import UIKit

protocol UpdatableWeatherArrayDataSourceDelegate: class {
    func removeRow(weather: WeatherRowItem)
}

class UpdatableWeatherArrayDataSource: UpdatableArrayDataSource<WeatherRowItem, WeatherServiceError> {
    weak var delegate: UpdatableWeatherArrayDataSourceDelegate?

    deinit {
        delegate = nil
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != 0 {
            return true
        } else {
            return false
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = elements[indexPath.row]
            removeItem(item, at: indexPath.row)
        }
    }

    func removeItem(_ item: WeatherRowItem, at index: Int) {
        let storedArray = UserDefaults.standard.userPreferences
        let filtered = storedArray.filter { $0 != item.title }
        UserDefaults.standard.userPreferences = filtered
        elements.remove(at: index)
        delegate?.removeRow(weather: item)
        reload()
    }
}
