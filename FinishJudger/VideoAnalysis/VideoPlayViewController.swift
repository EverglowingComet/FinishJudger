//
//  VideoPlayViewController.swift
//  FinishJudger
//
//  Created by Comet on 3/18/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit
import SCRecorder

class VideoPlayViewController: UITableViewController {

    @IBOutlet weak var playerView: UIView!
    
    let viewModel = CameraViewModel.sharedModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let player = SCPlayer()
        player.setItemBy(viewModel?.recorder.session?.assetRepresentingSegments())
        let playerLayer: AVPlayerLayer! = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer)
        
        player.play()
    }


}
