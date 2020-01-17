//
//  CameraViewController.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var myRecordButton: UIButton!
    @IBOutlet weak var myCameraView: CameraPreviewView!
    // MARK: - Properties
    
    var movieController: MovieController?
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var player: AVPlayer?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

//        recordButton.isHidden = true
        
        // Resize camera preview to fill the entire screen
        
        myCameraView.videoPlayerView.videoGravity = .resizeAspectFill
        
        setUpCamera()
        
        // TODO: Add tap gesture to replay the video (repeat loop)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGesture:)))
//        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        requestPermissionAndShowCamera()
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - Actions
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        toggleRecording()
    }
    
    // MARK: - Methods
    
    func playRecording() {
        if let player = player {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    func updateViews() {
        myRecordButton.isSelected = fileOutput.isRecording
    }
    
    func toggleRecording() {
        if fileOutput.isRecording {
            // stop
            fileOutput.stopRecording()
            
        } else {
            // start
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    private func setUpCamera() {
        /// get the best camera
        let camera = bestCamera()
        
        captureSession.beginConfiguration()
        
        // Make changes to the devices connected
        
        // Add inputs
        // Video inputs
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Cannot create camera input")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Cannot add camera input to session")
        }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.canSetSessionPreset(.hd1920x1080)
        }
        
        // Audio inputs
        
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("Can't create input from microphone")
        }
        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }
        captureSession.addInput(audioInput)
        
        // Video output (movie)
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Can't setup the file output for the movie")
        }
        captureSession.addOutput(fileOutput)
        
        
        captureSession.commitConfiguration()
        myCameraView.session = captureSession
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }
    
    /// WideAngle Lens is on every iPhone that's been shipped through 2019
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        // Fallback camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras on the device. Or you are running on the Simulator (not supported)")
    }
    
    
    
    /// Creates a new file URL in the documents directory
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        
        movieController?.createMovie(from: name)
        
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        print(segue.identifier)
//    }
}

// MARK: - Extensions

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        
//        print("Video: \(outputFileURL.path)")
        updateViews()
        
//        playMovie(url: outputFileURL)
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}
