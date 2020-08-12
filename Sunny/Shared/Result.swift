//
//  Result.swift
//  Sunny
//
//  Created by Polidea on 13/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

enum Result<T, E> {
    case success(T)
    case error(E)
}

extension Result {
    func map<R>(_ conversion: (T) -> R) -> Result<R, E> {
        switch self {
        case let .success(value):
            return .success(conversion(value))
        case let .error(error):
            return .error(error)
        }
    }

    func mapBoth<R, D>(_ left: (T) -> R, right: (E) -> D) -> Result<R, D> {
        switch self {
        case let .success(value):
            return .success(left(value))
        case let .error(error):
            return .error(right(error))
        }
    }
}
