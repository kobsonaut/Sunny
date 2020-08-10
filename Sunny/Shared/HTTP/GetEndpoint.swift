//
//  HTTPEndpoint.swift
//  Sunny
//
//  Created by Polidea on 13/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

struct GetEndpoint<Resource: Decodable> {
    let path: String
    let parameters: [String: Any]
}
