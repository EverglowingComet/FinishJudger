//
//  ViewController.swift
//  FinishJudger
//
//  Created by Comet on 3/17/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit
import MobileCoreServices
import SCRecorder

class CameraViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var timerLayout: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishLine: UIView!
    @IBOutlet weak var statusTable: UITableView!
    
    // Record Variables
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet var cameraView: UIView!
    
    let red = UIColor(displayP3Red: 1.0, green: 0, blue: 0, alpha: 1.0)
    let white = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let cameraViewModel = CameraViewModel.sharedModel()
    
    
    // Status Variables
    var gameTimerRunning = false
    var recordRunning = false
    
    // Timer variables
    var gameTimer = Timer()
    var gameStartTime : Double = 0
    var recordStartTime : Double = 0
    var gameTimeInCSeconds : Int = 0
    var gameTimeString : String = "00:00:00.00"
    var isVideoReady = false
    
    // Recording Queue
    var recordData : MatchRecordVideoData = MatchRecordVideoData(id: Utils.getDateTimeString(from: Date()), video_list: [])
    var curRecordingIndex = -1
    var curSavingIndex = -1
    
    // MARK: - UICallbacks
    override func viewDidLoad() {
//        navigationController?.navigationBar.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        UIApplication.shared.statusBarStyle = .default
        
        timerLayout.layer.cornerRadius = 8.0
        timerLayout.layer.masksToBounds = true
        
        startButton.layer.cornerRadius = 5.0
        startButton.layer.masksToBounds = true
        
        resetButton.layer.cornerRadius = 5.0
        resetButton.layer.masksToBounds = true
        
        recordButton.layer.cornerRadius = recordButton.bounds.width / 2
        resetButton.layer.masksToBounds = true
        
        cameraViewModel?.delegate = self
        
        finishLine.frame.origin.x = cameraView.frame.width / 2
        
        statusTable.dataSource = self
        statusTable.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cameraViewModel?.initRecorder(with: cameraView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_video" {
            var vc = segue.destination as! VideoPlayViewController
            vc.matchVideo = recordData
            vc.matchInfo = Match.getSampleMatch()
        }
    }
    
    @IBAction func triggerTimer(_ sender: UIButton) {
        triggerTimer()
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
        if !gameTimerRunning {
            triggerTimer()
        }
        cameraViewModel?.toggleRecording()
        cameraViewModel?.file_path = Utils.getVideoFilePath(cseceonds: gameTimeInCSeconds, match_id: recordData.identifier)
    }
    @IBAction func openAnalysis(_ sender: Any) {
        if isVideoReady {
            performSegue(withIdentifier: "show_video", sender: nil)
        } else {
            Utils.showAlert(viewController: self, title: "Attention", msg: "Vidoe data is not ready, retry after saving video completed", buttonTitle: "Ok", handler: nil)
        }
    }
    // MARK: - Timer functions
    func triggerTimer() {
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
        
        self.gameTimeString = Utils.getCSecondsString(cseceonds: gameTimeInCSeconds)
        
        self.timeLabel.text = self.gameTimeString
    }
    
    @objc func gameTimerBody() {
        updateCurrentTime()
    }
    
}

extension CameraViewController : CameraViewModelDelegate {
    func recordFinished(file_path: String) {
        recordData.videos[curSavingIndex].filePath = file_path
        recordData.videos[curSavingIndex].currentStatus = MatchRecordItem.SAVED
        recordData.videos[curRecordingIndex].durationCSeconds = gameTimeInCSeconds - recordData.videos[curRecordingIndex].startTimeCSeconds
        DispatchQueue.main.async {
            self.statusTable.reloadData()
        }
        cameraViewModel?.reinitRecorder()
        curSavingIndex = -1
        isVideoReady = true
    }
    
    func recordStatusToggled(isRecording: Bool) {
        if isRecording {
            isVideoReady = false
            recordButton.setTitle("STOP", for: .normal)
            recordButton.backgroundColor = white
            recordButton.setTitleColor(red, for: .normal)
            
            curRecordingIndex = recordData.videos.count
            recordData.videos.append(MatchRecordItem(startTime: gameTimeInCSeconds, status: MatchRecordItem.RECORDING, path: cameraViewModel?.file_path))
            
            statusTable.reloadData()
        } else {
            recordButton.setTitle("START", for: .normal)
            recordButton.backgroundColor = red
            recordButton.setTitleColor(white, for: .normal)
            curSavingIndex = curRecordingIndex
            recordData.videos[curSavingIndex].currentStatus = MatchRecordItem.SAVING
            statusTable.reloadData()
            curRecordingIndex = -1
        }
    }
    
    func recordFailed(error: String) {
        if curSavingIndex != -1 {
            recordData.videos[curSavingIndex].currentStatus = MatchRecordItem.FAILED
            DispatchQueue.main.async {
                self.statusTable.reloadData()
            }
            cameraViewModel?.reinitRecorder()
            curSavingIndex = -1
        }
        isVideoReady = false
    }
}

extension CameraViewController : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension CameraViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordData.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "camera_record_item", for: indexPath) as! CameraRecordItem
        
        cell.startTime.text = Utils.getCSecondsString(cseceonds: recordData.videos[indexPath.row].startTimeCSeconds)
        cell.currentStatus.text = recordData.videos[indexPath.row].currentStatus
        cell.wrpper.layer.cornerRadius = 3
        
        return cell
    }
}
