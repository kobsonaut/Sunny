//
//  LocationService.swift
//  Sunny
//
//  Created by Polidea on 13/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import CoreLocation

enum LocationServiceError: Error {
    case locationManagerFailed(Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {

    typealias LocationUpdateBlock = (Result<CLLocation, LocationServiceError>) -> Void

    private(set) var lastLocation: CLLocation? {
        didSet {
            if let value = lastLocation {
                currentObserverBlock?(.success(value))
            }
        }
    }

    private var currentObserverBlock: LocationUpdateBlock?
    
    var isEnabled: Bool {
        return currentObserverBlock != nil
    }

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        manager.requestWhenInUseAuthorization()
        return manager
    }()

    func enable(with block: @escaping LocationUpdateBlock) {
        currentObserverBlock = block
        locationManager.startUpdatingLocation()
    }

    func disable() {
        currentObserverBlock = nil
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        currentObserverBlock?(.error(.locationManagerFailed(error)))
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
            lastLocation = last
        }
    }
}
