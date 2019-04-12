//
//  VideoPlayerView.swift
//  FinishJudger
//
//  Created by MacMaster on 4/11/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit

protocol TouchGuestureDelgate {
    func onTouchBegan(location: CGPoint)
    func onTouchMove(location: CGPoint)
    func onTouchEnded(location: CGPoint)
}

class VideoPlayerView: UIView {
    var touchDelegate : TouchGuestureDelgate?
    var touchBeganPoint : CGPoint?
    var touchEndPoint : CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let location = touches.first?.location(in: self), touchDelegate != nil {
            touchBeganPoint = location
            touchDelegate!.onTouchBegan(location: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let location = touches.first?.location(in: self), touchDelegate != nil {
            touchDelegate!.onTouchMove(location: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let location = touches.first?.location(in: self), touchDelegate != nil {
            touchEndPoint = location
            touchDelegate!.onTouchEnded(location: location)
        }
    }
}
