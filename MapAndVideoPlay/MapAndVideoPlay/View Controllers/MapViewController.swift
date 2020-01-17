//
//  MapViewController.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    let movieController = MovieController()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: PropertyKeys.movieMapView)
        
        let coordinates = makeCoordinates()
        
    }
    /// 47.200953,-122.564484   48.083626,-121.963246
    func makeCoordinates() -> [CLLocation] {
        var coordinates: [CLLocation] = []
        let latitudeRange = 47_200_953...48_083_626
        let longitudeRange = -122_564_484...(-121_963_246)
        
        for _ in 1...10 {
            let latitude = Double(Int.random(in: latitudeRange)/1_000_000)
            let longitude = Double(Int.random(in: longitudeRange) / 1_000_000)
            
            coordinates.append(CLLocation(latitude: latitude, longitude: longitude))
            
        }
        
        mapView.addAnnotations(movieController.moviesWithCoordinates)
        return coordinates
    }
    
    @IBAction func showTableView(_ sender: Any) {
        print("test")
        performSegue(withIdentifier: PropertyKeys.tableViewSegue, sender: nil)
        
        
    }
    
    func showMovieLocations() {
//        self.mapView.addAnnotation()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.tableViewSegue {
            guard let tableVC = segue.destination as? MovieTitlesTableViewController else { return }
            tableVC.movieController = movieController
        }
    }
    

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let movie = annotation as? MovieWithCoordinates else { fatalError("Only Movies with coordinates are supported right now") }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PropertyKeys.movieMapView) as? MKMarkerAnnotationView else { fatalError("Missing registered map annotation view") }
        
        annotationView.canShowCallout = true
        
        return annotationView
        
    }
}
