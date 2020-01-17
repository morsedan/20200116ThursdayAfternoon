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
    var moviesWithCoordinates: [MovieWithCoordinates] = []
    
    // CRUD
    func createMovie(from name: String, at date: Date = Date()) {
        let movie = Movie(locationString: name, date: date)
        
        movies.append(movie)
        sortMovies()
        saveToFile(movies: movies)
    }
    
    func deleteMovie(_ movie: Movie) {
        guard let index = movies.firstIndex(of: movie) else { return }
        movies.remove(at: index)
        sortMovies()
        saveToFile(movies: movies)
    }
    
    // MARK: - Private
    
    private func sortMovies() {
        movies = movies.sorted { $0.date < $1.date }
    }
    
    var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("movies").appendingPathExtension("plist")
        return archiveURL
    }
    
    func saveToFile(movies: [Movie]) {
        let propertyListEncoder = PropertyListEncoder()
        let encoded = try? propertyListEncoder.encode(movies)
        try? encoded?.write(to: archiveURL, options: .noFileProtection)
    }
    
    @discardableResult func loadFromFile() -> [Movie] {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURL) {
            let decodedData = try? propertyListDecoder.decode([Movie].self, from: retrievedData)
            guard let decoded = decodedData else { return [] }
            movies = decoded
            return decoded
        }
        return []
    }
}
