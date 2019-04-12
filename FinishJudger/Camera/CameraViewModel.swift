//
//  CameraViewModel.swift
//  PlayerVideo
//
//  Created by user on 3/20/19.
//  Copyright © 2019 KMHK. All rights reserved.
//

import UIKit
import SCRecorder
import Photos


var sharedCameraViewModel: CameraViewModel?

let maxDuration = 1000


protocol CameraViewModelDelegate: AnyObject {
    func recordStatusToggled(isRecording: Bool)
    func recordFailed(error: String)
    func recordFinished(file_path: String)
}


class CameraViewModel: NSObject
{
    // MARK: memeber variable
    
    var recorder = SCRecorder()
    weak var delegate: CameraViewModelDelegate?
    var file_path : String? = nil
    
    // MARK: static method
    
    static func sharedModel() -> CameraViewModel? {
        if sharedCameraViewModel == nil {
            sharedCameraViewModel = CameraViewModel()
        }
        
        return sharedCameraViewModel
    }
    
    // MARK: life cycling
    
    override init() {
        super.init()
        
        setupRecorder()
    }
    
    // MARK: video recorder initialize
    
    func initRecorder(with view: UIView!) {
        recorder.videoConfiguration.size = view.bounds.size
        recorder.previewView = view
    }
    
    func releaseRecorder() {
        recorder.stopRunning()
    }
    
    func toggleRecording() {
        if recorder.isRecording {
            recorder.pause {[weak self] in
                self?.pauseCompleted()
            }
            recorder.stopRunning()
            
        } else {
            recorder.record()
            
            delegate?.recordStatusToggled(isRecording: true)
        }
    }
    
    func pauseCompleted() {
        delegate?.recordStatusToggled(isRecording: false)
    }
    
    // MARK: private method
    
    private func setupRecorder() {
        //weak var weakSelf = self
        
        recorder.captureSessionPreset = SCRecorderTools.bestCaptureSessionPresetCompatibleWithAllDevices()
        recorder.device = .back
        recorder.maxRecordDuration = CMTime(value: CMTimeValue(maxDuration * 1000), timescale: 1000)
        recorder.delegate = self
        
        let video = recorder.videoConfiguration
        video.enabled = true
        video.scalingMode = AVVideoScalingModeResizeAspectFill
        video.timeScale = 1.0
        video.maxFrameRate = 30
        
        let audio = recorder.audioConfiguration
        audio.enabled = true
        audio.bitrate = 128000
        audio.channelsCount = 1
        audio.sampleRate = 0
        audio.format = Int32(kAudioFormatMPEG4AAC)
        
        recorder.session = SCRecordSession()
        recorder.session?.fileType = AVFileType.mov.rawValue
        
        recorder.startRunning()
    }
    
    func reinitRecorder() {
        recorder.stopRunning()
        
        recorder.session = SCRecordSession()
        recorder.session?.fileType = AVFileType.mov.rawValue
        
        recorder.startRunning()
    }
}


// MARK: - SCRecorder delegate

extension CameraViewModel: SCRecorderDelegate
{
    func recorder(_ recorder: SCRecorder, didComplete session: SCRecordSession) {
        NSLog("recorder didComlete")
        session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
            if (error == nil) {
                if url != nil && self.file_path != nil {
                    try? FileManager.default.copyItem(at: url!, to: URL(fileURLWithPath: self.file_path!))
                    if FileManager.default.fileExists(atPath: self.file_path!) {
                        PHPhotoLibrary.requestAuthorization { (status) in
                            if status == PHAuthorizationStatus.authorized {
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: self.file_path!))
                                }) { completed, error in
                                    if completed {
                                        self.delegate?.recordFinished(file_path: self.file_path!)
                                    } else {
                                        self.delegate?.recordFailed(error: "File url is invalid")
                                    }
                                }
                            } else {
                                self.delegate?.recordFailed(error: "Photo library permission denied")
                            }
                        }
                    } else {
                        self.delegate?.recordFailed(error: "Temp file copy failed")
                    }
                } else {
                    self.delegate?.recordFailed(error: "Invalid temp url or file url")
                }
            } else {
                print(error as Any)
                self.delegate?.recordFailed(error: "Merge Session failed")
            }
        }
    }
    
    func recorder(_ recorder: SCRecorder, didComplete segment: SCRecordSessionSegment?, in session: SCRecordSession, error: Error?) {
        NSLog("recorder didComlete with segment")
        session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
            if (error == nil) {
                if url != nil && self.file_path != nil {
                    try? FileManager.default.copyItem(at: url!, to: URL(fileURLWithPath: self.file_path!))
                    if FileManager.default.fileExists(atPath: self.file_path!) {
                        PHPhotoLibrary.requestAuthorization { (status) in
                            if status == PHAuthorizationStatus.authorized {
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: self.file_path!))
                                }) { completed, error in
                                    if completed {
                                        self.delegate?.recordFinished(file_path: self.file_path!)
                                    } else {
                                        self.delegate?.recordFailed(error: "File url is invalid")
                                    }
                                }
                            } else {
                                self.delegate?.recordFailed(error: "Photo library permission denied")
                            }
                        }
                    } else {
                        self.delegate?.recordFailed(error: "Temp file copy failed")
                    }
                } else {
                    self.delegate?.recordFailed(error: "Invalid temp url or file url")
                }
            } else {
                print(error as Any)
                self.delegate?.recordFailed(error: "Merge Session failed")
            }
        }
    }
}

// MARK: - SCAssetExportSession delegate

extension CameraViewModel: SCAssetExportSessionDelegate
{
    
}
