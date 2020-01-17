//
//  Movie+MKAnnotation.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation
import MapKit

extension MovieWithCoordinates: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        "ABC"
    }
    
    var subtitle: String? {
        "123"
    }
}
