//
//  VideoPlayViewController.swift
//  FinishJudger
//
//  Created by Comet on 3/18/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit
import SCRecorder
import CoreMedia

class VideoPlayViewController: UIViewController {

    // MARK: - UIControls
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var current_time: UILabel!
    @IBOutlet weak var video_length: UILabel!
    @IBOutlet weak var seeker: UISlider!
    @IBOutlet weak var play_btn: UIButton!
    @IBOutlet weak var save_btn: UIButton!
    @IBOutlet weak var controllerTable: UITableView!
    @IBOutlet weak var showPlayerBtn: UIButton!
    @IBOutlet weak var showVideoBtn: UIButton!
    @IBOutlet weak var controllerView: UIView!
    @IBOutlet weak var controllerHeader: UIView!
    @IBOutlet weak var controllerTitle: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var speed_text: UILabel!
    @IBOutlet weak var title_text: UILabel!
    
    @IBOutlet weak var speed_fifth: UIButton!
    @IBOutlet weak var speed_half: UIButton!
    @IBOutlet weak var speed_normal: UIButton!
    
    @IBOutlet weak var finishLine: UIView!
    @IBOutlet weak var swipeLayout: UIView!
    @IBOutlet weak var swipeSetting: UISegmentedControl!
    
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var gameTimePopup: UILabel!
    // MARK: - Constants
    static let STATUS_VIDEO = 0
    static let STATUS_PLAYER = 1
    static let VIDEO_CELL_ID = "video_item"
    static let PLAYER_CELL_ID = "player_item"
    static let SPEED_NORMAL = 0
    static let SPEED_SLOW = 1
    static let SPEED_EX_SLOW = 2
    static let SPEED_VLUES: [Float] = [1.0, 0.5, 0.2]
    static let SWIPE_TIME = 0
    static let SWIPE_LINE = 1
    
    // MARK: - Member attributes
    private var isPaused = false
    private var videoPlayer: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var curIndex = 0
    private var periodicTimeObserver: Any!
    private var tabStatus = STATUS_VIDEO
    private var tabHidden = true
    private var curSpeedStatus = SPEED_NORMAL
    private var swipeStatus = SWIPE_TIME
    private var isSwiping = false
    private var swipeBeganTime = -1
    private var swipeBeganLineX : CGFloat = -1
    
    // MARK: - External Data Feed
    var matchVideo : MatchRecordVideoData? = nil
    var matchInfo : Match? = nil
    
    // MARK: - UI functions
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        UIApplication.shared.statusBarStyle = .default
        
        let url = URL(fileURLWithPath: matchVideo!.videos[0].filePath!)
        videoPlayer = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer)
        videoPlayer.play()
        
        videoPlayer.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        addTimeObserver()
        
        updatePlayButton()
        
        controllerTable.dataSource = self
        controllerTable.delegate = self
        statusView.layer.cornerRadius = 5
        controllerView.layer.cornerRadius = 5
        controllerHeader.layer.cornerRadius = 5
        swipeLayout.layer.cornerRadius = 5
        
        speed_normal.layer.cornerRadius = speed_normal.frame.width / 2
        speed_half.layer.cornerRadius = speed_half.frame.width / 2
        speed_fifth.layer.cornerRadius = speed_fifth.frame.width / 2
        
        title_text.text = "Title: " + (matchInfo?.title)!
        updateSpeedStatus()
        updateControllerTable()
        
        playerView.touchDelegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = videoPlayer.currentItem?.duration.seconds, duration > 0.0 {
            let txt =  Utils.getTimeString(from: videoPlayer.currentItem!.duration)
            self.video_length.text = txt
        }
    }

    @IBAction func playPressed(_ sender: UIButton) {
        togglePlay()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
    }
    
    @IBAction func showPlayerTable(_ sender: Any) {
        controllerTitle.text = "Players"
        if tabHidden || tabStatus == VideoPlayViewController.STATUS_VIDEO {
            tabStatus = VideoPlayViewController.STATUS_PLAYER
            tabHidden = false
        } else {
            tabHidden = true
        }
        updateControllerTable()
    }
    
    @IBAction func showVideoTable(_ sender: Any) {
        controllerTitle.text = "Videos"
        if tabHidden || tabStatus == VideoPlayViewController.STATUS_PLAYER {
            tabStatus = VideoPlayViewController.STATUS_VIDEO
            tabHidden = false
        } else {
            tabHidden = true
        }
        updateControllerTable()
    }
    
    @IBAction func speed_normal(_ sender: UIButton) {
        curSpeedStatus = VideoPlayViewController.SPEED_NORMAL
        updateSpeedStatus()
    }
    
    @IBAction func speed_half(_ sender: Any) {
        curSpeedStatus = VideoPlayViewController.SPEED_SLOW
        updateSpeedStatus()
    }
    
    
    @IBAction func speed_fifth(_ sender: Any) {
        curSpeedStatus = VideoPlayViewController.SPEED_EX_SLOW
        updateSpeedStatus()
    }
    
    @IBAction func swipeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            swipeStatus = VideoPlayViewController.SWIPE_TIME
        } else {
            swipeStatus = VideoPlayViewController.SWIPE_LINE
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        videoPlayer.seek(to: CMTimeMake(value: Int64(sender.value * 1000), timescale: 1000))
    }
    
    // MARK: - Control functions
    func togglePlay() {
        isPaused = !isPaused
        if isPaused {
            videoPlayer.pause()
        } else {
            videoPlayer.play()
        }
        updatePlayButton()
    }
    
    func updatePlayButton() {
        if isPaused {
            if let image = UIImage(named: "play.png") {
                play_btn.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(named: "pause.png") {
                play_btn.setImage(image, for: .normal)
            }
        }
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        periodicTimeObserver = videoPlayer.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {[weak self] time in
            guard let currentItem = self?.videoPlayer.currentItem else {return}
            if Float(currentItem.duration.seconds) > 0 {
                self?.seeker.maximumValue = Float(currentItem.duration.seconds)
                self?.seeker.minimumValue = 0
                self?.seeker.value = Float(currentItem.currentTime().seconds)
                self?.current_time.text = Utils.getTimeString(from: currentItem.currentTime())
                if currentItem.duration.seconds <= currentItem.currentTime().seconds {
                    if self!.curIndex < (self!.matchVideo?.videos.count)! - 1 {
                        self!.playVideo(index: self!.curIndex + 1)
                    } else {
                        self?.videoPlayer.seek(to: CMTimeMake(value: 0, timescale: 1000))
                        self?.seeker.value = 0
                        self?.togglePlay()
                    }
                }
            }
        })
    }
    
    func updateSpeedStatus() {
        switch curSpeedStatus {
        case VideoPlayViewController.SPEED_EX_SLOW:
            speed_text.text = "Sp.1/5x"
        case VideoPlayViewController.SPEED_SLOW:
            speed_text.text = "Sp.1/2x"
        default:
            speed_text.text = "Sp.1x"
        }
        videoPlayer.rate = VideoPlayViewController.SPEED_VLUES[curSpeedStatus]
    }
    
    func updateControllerTable() {
        controllerView.isHidden = tabHidden
        controllerView.isUserInteractionEnabled = !tabHidden
        if !tabHidden {
            controllerTable.reloadData()
        }
    }
    
    func playVideo(index: Int) {
        curIndex = index
        if let path = matchVideo?.videos[index].filePath {
            //videoPlayer
            videoPlayer.pause()
            videoPlayer.removeTimeObserver(periodicTimeObserver)
            videoPlayer.currentItem?.removeObserver(self, forKeyPath: "duration")
            videoPlayer.replaceCurrentItem(with: AVPlayerItem(url: URL(fileURLWithPath: path)))
            videoPlayer.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
            addTimeObserver()
            videoPlayer.play()
        }
    }
    
    func setPlayerRecord(index: Int) {
        if let player = matchInfo?.players[index] {
            if player.recordsCSec == -1 {
                player.recordsCSec = Int((videoPlayer.currentItem?.currentTime().seconds)! * 100) + (matchVideo?.videos[curIndex].startTimeCSeconds)!
                player.rank = getPlayerRank(csec: player.recordsCSec)
                updateControllerTable()
            } else {
                Utils.showQAlert(viewController: self, title: "Attention", msg: "Do you want to cancel player's record?", handler: { (UIAlertAction)-> Void in
                    player.recordsCSec = -1
                    player.rank = -1
                    self.updateControllerTable()
                })
            }
        }
    }
    
    func getPlayerRank(csec: Int) -> Int {
        var rank = 1
        for player in (matchInfo?.players)! {
            if csec > player.recordsCSec {
                rank += 1
            }
        }
        return rank
    }
    
    func saveInfos() {
        matchVideo?.saveToStorage()
        matchInfo?.saveToStorage(video_id: (matchVideo?.identifier)!)
        
    }
}

extension VideoPlayViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabStatus == VideoPlayViewController.STATUS_VIDEO {
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoPlayViewController.VIDEO_CELL_ID, for: indexPath) as! VideoItemCell
            if let file_paths = matchVideo?.videos[indexPath.row].filePath?.split(separator: "/"), let name : Substring = file_paths[file_paths.count - 1] {
                
                cell.video_file_name.text = String(name)
                cell.video_time_span.text = Utils.getCSecondsString(cseceonds: (matchVideo?.videos[indexPath.row].startTimeCSeconds)!) + "s"
            }
            cell.layer.cornerRadius = 5
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoPlayViewController.PLAYER_CELL_ID, for: indexPath) as! PlayerItemCell

            if let player = matchInfo?.players[indexPath.row] {
                
                cell.player_name.text = player.last_name + " " + player.first_name
                cell.player_number.text = "No. " + String(player.number)
                cell.rank.text = player.rank == -1 ? Utils.RANK_PLACEHOLDER : String(player.rank)
                cell.record.text = player.recordsCSec == -1 ? Utils.RECORD_PLACEHOLDER : Utils.getCSecondsString(cseceonds: player.recordsCSec)
            }
            cell.layer.cornerRadius = 5
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabStatus == VideoPlayViewController.STATUS_VIDEO {
            return matchVideo?.videos.count ?? 0
        } else {
            return matchInfo?.players.count ?? 0
        }
    }
    
    func getSwipedTime(swiped: Float, start_point: Int, duration: Int) -> Int {
        let result = start_point + Int(Float(duration) * swiped * VideoPlayViewController.SPEED_VLUES[curSpeedStatus])
        return result
    }
}

extension VideoPlayViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tabStatus == VideoPlayViewController.STATUS_VIDEO {
            playVideo(index: indexPath.row)
        } else {
            setPlayerRecord(index: indexPath.row)
        }
    }
}

extension VideoPlayViewController : TouchGuestureDelgate {
    func onTouchBegan(location: CGPoint) {
        isSwiping = true
        if swipeStatus == VideoPlayViewController.SWIPE_TIME {
            videoPlayer.pause()
            isPaused = true
            updatePlayButton()
            swipeBeganTime = Int((videoPlayer.currentItem?.currentTime().seconds ?? -0.01) * 100)
            self.gameTimePopup.isHidden = false
        } else {
            swipeBeganLineX = finishLine.center.x
        }
    }
    
    func onTouchMove(location: CGPoint) {
        if isSwiping && self.playerView.touchBeganPoint != nil {
            let deltaX = location.x - self.playerView.touchBeganPoint!.x
            
            if swipeStatus == VideoPlayViewController.SWIPE_TIME {
                let duration = Int((videoPlayer.currentItem?.duration.seconds ?? -0.01) * 100)
                if duration != -1 {
                    let seconds = self.getSwipedTime(swiped: Float(deltaX / self.playerView.frame.width), start_point: swipeBeganTime, duration: duration)
                    let cmTimeZero = CMTimeMake(value: 0, timescale: 100)
                    videoPlayer.seek(to: CMTimeMake(value: Int64(seconds), timescale: 100), toleranceBefore: cmTimeZero, toleranceAfter: cmTimeZero, completionHandler: {(success) in
                        
                        DispatchQueue.main.async {
                            
                            let game_time = Int((self.videoPlayer.currentItem?.currentTime().seconds)! * 100) + (self.matchVideo?.videos[self.curIndex].startTimeCSeconds)!
                            
                            self.current_time.text = Utils.getCSecondsString(cseceonds: Int((self.videoPlayer.currentItem?.currentTime().seconds)! * 100))
                            self.gameTime.text = Utils.getCSecondsString(cseceonds: game_time)
                            self.gameTimePopup.text = "[" + Utils.getCSecondsString(cseceonds: game_time) + "]"
                            
                            self.seeker.maximumValue = Float(duration) / 100
                            self.seeker.minimumValue = 0
                            self.seeker.value = Float(seconds) / 100
                        }
                    })
                    
                }
            } else if swipeStatus == VideoPlayViewController.SWIPE_LINE {
                var transformedX = swipeBeganLineX + deltaX
                
                if transformedX < 10 {
                    transformedX = 10
                }
                
                if transformedX > playerView.frame.width - 10 {
                    transformedX = playerView.frame.width - 10
                }
                
                finishLine.center.x = transformedX
            }
        }
    }
    
    func onTouchEnded(location: CGPoint) {
        isSwiping = false
        swipeBeganTime = -1
        swipeBeganLineX = -1 as CGFloat
        gameTimePopup.isHidden = true
    }
    
    
}
