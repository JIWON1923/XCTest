//
//  DistanceCalculator.swift
//  TravelApp
//
//  Created by 이지원 on 2023/05/15.
//

import Foundation
import CoreLocation

final class DistancaCaculator {
    
    enum Error: Swift.Error, Equatable {
        case unknownCity(_ city: String)
    }
    
    struct City {
        let name: String
        let coordinates: (latitude: Double, longitude: Double)
    }
    
    private let cities = [
        "NewYork"    : City(name: "New York", coordinates: (latitude: 40.7128, longitude: -74.0060)),
        "Paris"      : City(name: "Paris", coordinates: (latitude: 48.8566, longitude:2.3522)),
        "Tokyo"      : City(name: "Tokyo", coordinates: (latitude: 35.5896, longitude: 139.6917)),
        "London"     : City(name: "London", coordinates: (latitude: 51.5074, longitude: -0.1278))
    ]
    
    func city(forName city: String) -> City? {
        cities[city]
    }
    
    func distanceInMiles(from origin: String, to destination: String) throws -> Double {
        guard let fromCity = city(forName: origin) else {
            throw Error.unknownCity(origin)
        }
        
        guard let toCity = city(forName: destination) else {
            throw Error.unknownCity(destination)
        }
        
        return distanceInMiles(from: fromCity, to: toCity)
    }
    
    func distanceInMiles(from fromCity: City, to toCity: City) -> Double {
        let fromLocation = CLLocation(latitude: fromCity.coordinates.latitude, longitude: fromCity.coordinates.longitude)
        let toLocation = CLLocation(latitude: toCity.coordinates.latitude, longitude: toCity.coordinates.longitude)
        let distanceInMeters = Measurement(value: fromLocation.distance(from: toLocation), unit: UnitLength.meters)
        return distanceInMeters.converted(to: UnitLength.miles).value
    }
}
