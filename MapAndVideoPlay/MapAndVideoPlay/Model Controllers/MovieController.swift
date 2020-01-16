//
//  MovieController.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

class MovieController {
    var movies: [Movie] = []
    
    // CRUD
    func createMovie(from url: URL, at date: Date = Date()) {
        let movie = Movie(movieDataLocation: url, date: date)
        
        movies.append(movie)
        sortMovies()
    }
    
    func deleteMovie(_ movie: Movie) {
        guard let index = movies.firstIndex(of: movie) else { return }
        movies.remove(at: index)
        sortMovies()
    }
    
    // MARK: - Private
    
    private func sortMovies() {
        movies = movies.sorted { $0.date < $1.date }
    }
    
    static var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("movies").appendingPathExtension("plist")
        return archiveURL
    }
    
    static func saveToFile(movies: [Movie]) {
        let propertyListEncoder = PropertyListEncoder()
        let encoded = try? propertyListEncoder.encode(movies)
        try? encoded?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Movie] {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURL) {
            let decodedData = try? propertyListDecoder.decode([Movie].self, from: retrievedData)
            guard let decoded = decodedData else { return [] }
            return decoded
        }
        return []
    }
}
