//
//  Movie.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

struct Movie: Codable, Equatable {
    let movieDataLocation: URL
    let date: Date
}
