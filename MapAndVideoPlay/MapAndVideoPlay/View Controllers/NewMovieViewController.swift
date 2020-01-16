//
//  NewMovieViewController.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import AVFoundation

class NewMovieViewController: UIViewController {
    
    // MARK: - Properties
    
    var movieController: MovieController?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestPermissionAndShowCamera()
        
    }
    
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.showCameraSegue {
            guard let cameraVC = segue.destination as? CameraViewController else { return }
            cameraVC.movieController = movieController
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
