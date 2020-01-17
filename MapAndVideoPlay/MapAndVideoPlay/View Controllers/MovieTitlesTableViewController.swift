//
//  MovieTitlesTableViewController.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import AVFoundation

class MovieTitlesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var movieController: MovieController?
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL dd yyyy 'at' h:mm:ss a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        movieController?.loadFromFile()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieController?.movies.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.videoTitleCell, for: indexPath)

        guard let movie = movieController?.movies[indexPath.row] else { return UITableViewCell() }
        let dateString = dateFormatter.string(from: movie.date)
        cell.textLabel?.text = dateString

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let movie = movieController?.movies[indexPath.row] else { return }
            movieController?.deleteMovie(movie)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Authorization
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            
        case .notDetermined:
            // First time user - they haven't seen the permission dialog
            requestPermission()
        case .restricted:
            // Parental controls disabled the camera
            fatalError("Video is disabled for the user (parental controls?)")
            // TODO: Add UI to inform the user (talk to parents)
        case .denied:
            // User did not give access (possibly on accident)
            fatalError("Tell the user they need to enable Privacy for Video")
            // TODO: Add UI to inform user how
        case .authorized:
            // We asked for permission (2nd+ time they used the app)
            showCamera()
        @unknown default:
            fatalError("A new status was added that we need to handle")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user they need to enable Privacy for Video")
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                self.showCamera()
            }
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: PropertyKeys.showCameraSegue, sender: self)
    }

    // MARK: - Navigation
    
    @IBAction func requestPermissionsOrShowCamera(_ sender: Any) {
        requestPermissionAndShowCamera()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.showCameraSegue {
            guard let createVC = segue.destination as? CameraViewController else { return }
            createVC.movieController = movieController
        } else if segue.identifier == PropertyKeys.viewVideoSegue {
            guard let viewVideoVC = segue.destination as? ShowVideoViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            viewVideoVC.movie = movieController?.movies[indexPath.row]
        }
    }
}
