//
//  LanguageManager.swift
//  Sunny
//
//  Created by Kobsonauta on 14/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import Foundation

final class LanguageManager {

    // MARK: Members and properties
    public static let shared: LanguageManager = LanguageManager()

    // MARK: Init
    private init() {

    }

    // MARK: Helpers
    func localizedString(forKey key: String?) -> String {
        guard let str_key = key else {
            return ""
        }
        let str = NSLocalizedString(str_key, comment: "")

        return str
    }
}
