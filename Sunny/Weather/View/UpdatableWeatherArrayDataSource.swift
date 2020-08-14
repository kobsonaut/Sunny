//
//  UpdatableWeatherArrayDataSource.swift
//  Sunny
//
//  Created by Kobsonauta on 14/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import Foundation
import UIKit

class UpdatableWeatherArrayDataSource: UpdatableArrayDataSource<WeatherRowItem, WeatherServiceError> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = elements[indexPath.row]
            let storedArray = UserDefaults.standard.userPreferences
            let filtered = storedArray.filter { $0 != item.title }
            UserDefaults.standard.userPreferences = filtered
            elements.remove(at: indexPath.row)
            reload()
        }
    }
}
