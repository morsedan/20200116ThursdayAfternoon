//
//  Movie.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

class Movie: NSObject, Codable {
    
    let locationString: String
    var movieDataURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(locationString).appendingPathExtension("mov")
    }
    let date: Date
    
    init(locationString: String, date: Date = Date()) {
        self.locationString = locationString
        self.date = date
    }
}

class MovieWithCoordinates: NSObject, Codable {
    let locationString: String
    var movieDataURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(locationString).appendingPathExtension("mov")
    }
    let date: Date
    let latitude: Double
    let longitude: Double
    
    init(locationString: String, date: Date = Date(), latitude: Double, longitude: Double) {
        self.locationString = locationString
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
    }
}
