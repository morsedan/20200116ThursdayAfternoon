//
//  ViewController.swift
//  MapAndVideoPlay
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import AVFoundation

class ShowVideoViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var movie: Movie? {
        didSet {
            updateViews()
        }
    }
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == .ended {
            playRecording()
        }
    }

    func updateViews() {
        guard let url = movie?.movieDataURL else { return }
        playMovie(url: url)
    }
    
    func playRecording() {
        if let player = player {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    func playMovie(url: URL) {
        
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        
        // TODO: customize rectangle bounds
        var topRect = view.bounds
        topRect.size.height = topRect.height / 4
        topRect.size.width = topRect.width / 4
        topRect.origin.y = view.layoutMargins.top
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        player?.play()
        
        // TODO: addd delagate and repeat video if at end
    }

}

