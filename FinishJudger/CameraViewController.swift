//
//  ViewController.swift
//  FinishJudger
//
//  Created by Comet on 3/17/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit
import MobileCoreServices

class CameraViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var timerLayout: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    // Status Variables
    var gameTimerRunning = false
    var recordRunning = false
    
    // Timer variables
    var gameTimer = Timer()
    var gameStartTime : Double = 0
    var recordStartTime : Double = 0
    var gameTimeInCSeconds : Int = 0
    var gameTimeString : String = "00:00:00.00"
    
    override func viewDidLoad() {
        timerLayout.layer.cornerRadius = 8.0
        timerLayout.layer.masksToBounds = true
        
        startButton.layer.cornerRadius = 5.0
        startButton.layer.masksToBounds = true
        
        resetButton.layer.cornerRadius = 5.0
        resetButton.layer.masksToBounds = true
        
        recordButton.layer.cornerRadius = recordButton.bounds.width / 2
        resetButton.layer.masksToBounds = true
    }
    
    // Timer functions
    @objc func gameTimerBody() {
        updateCurrentTime()
    }
    
    func updateTimeControls() {
        if gameTimerRunning {
            resetButton.isEnabled = false
            resetButton.alpha = 0.5
            
            startButton.setTitle("PAUSE", for: .normal)
        } else {
            resetButton.isEnabled = true
            resetButton.alpha = 1
                        
            startButton.setTitle("START", for: .normal)
        }
    }
    
    func updateCurrentTime() {
        let current = CACurrentMediaTime()
        
        self.gameTimeInCSeconds = Int((current - self.gameStartTime)  * 100)
        
        self.gameTimeString = (CameraViewController.getTwoDigitStr(value: gameTimeInCSeconds / 360000) + ":" +
            CameraViewController.getTwoDigitStr(value: gameTimeInCSeconds / 6000) + ":" +
            CameraViewController.getTwoDigitStr(value: gameTimeInCSeconds / 100) + "." +
            CameraViewController.getTwoDigitStr(value: gameTimeInCSeconds % 100))
        
        self.timeLabel.text = self.gameTimeString
    }
    
    class func getTwoDigitStr(value : Int) -> String {
        return value > 9 ? String(value) : ("0" + String(value))
    }
    
    @IBAction func triggerTimer(_ sender: UIButton) {
        if gameStartTime == 0 {
            self.gameStartTime = CACurrentMediaTime()
        }
        if !gameTimerRunning {
            gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(gameTimerBody), userInfo: nil, repeats: true)
        } else {
            gameTimer.invalidate()
        }
        gameTimerRunning = !gameTimerRunning
        updateTimeControls()
    }
    
    @IBAction func resetTimer(_ sender: UIButton) {
        self.gameStartTime = CACurrentMediaTime()
        if gameTimerRunning {
            gameTimer.invalidate()
        }
        gameTimerRunning = false
        updateTimeControls()
        gameTimeString = "00:00:00.00"
        timeLabel.text = gameTimeString
    }
    
    @IBAction func recordVideo(_ sender: UIButton) {
        
    }
}
