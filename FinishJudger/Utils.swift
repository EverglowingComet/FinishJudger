//
//  Utils.swift
//  FinishJudger
//
//  Created by Comet on 3/21/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import Foundation
import CoreMedia
import UIKit

class Utils {
    
    static let RANK_PLACEHOLDER = "--"
    static let RECORD_PLACEHOLDER = "--:--:--.--"
    
    class func getTwoDigitStr(value : Int) -> String {
        return value > 9 ? String(value) : ("0" + String(value))
    }
    
    class func getCSecondsString(cseceonds: Int) -> String {
        return (getTwoDigitStr(value: cseceonds / 360000) + ":" +
            getTwoDigitStr(value: cseceonds / 6000 % 60) + ":" +
            getTwoDigitStr(value: cseceonds / 100 % 60) + "." +
            getTwoDigitStr(value: cseceonds % 100))
    }
    
    class private func ensureDirectories(match_id: String) -> String {
        let filemgr = FileManager.default
        
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsURL = dirPaths[0]
        
        let matchDir = docsURL.appendingPathComponent(match_id).path
        
        if !filemgr.fileExists(atPath: matchDir) {
            do{
                try filemgr.createDirectory(atPath: matchDir,withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        return matchDir
    }
    
    class func getVideoFilePath(cseceonds: Int, match_id: String) -> String {
        let matchDir = ensureDirectories(match_id: match_id)
        let file_name = (getTwoDigitStr(value: cseceonds / 360000) + "_" +
            getTwoDigitStr(value: cseceonds / 6000 % 60) + "_" +
            getTwoDigitStr(value: cseceonds / 100 % 60) + "-" +
            getTwoDigitStr(value: cseceonds % 100)) + ".mov"
        
        return "\(matchDir)/\(file_name)"
    }
    
    class func getMatchFilePath(match_id: String) -> String {
        let matchDir = ensureDirectories(match_id: match_id)
        
        return "\(matchDir)/match.json"
    }
    
    class func getMatchListFilePath() -> String {
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsPath = dirPaths[0].path
        
        return "\(docsPath)/match_list.json"
    }
    
    class func getPlayerRecordsFilePath(match_id: String) -> String {
        let matchDir = ensureDirectories(match_id: match_id)
        
        return "\(matchDir)/player_records.json"
    }
    
    class func getVideoRecFilePath(match_id: String) -> String {
        let matchDir = ensureDirectories(match_id: match_id)
        
        return "\(matchDir)/video_records.json"
    }
    
    class func getTimeString(from time: CMTime) -> String {
        
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let mins = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours, mins, seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [mins, seconds])
        }
    }
    
    class func getDateTimeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: date)
    }
    
    class func getDateTime(from date_str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.date(from: date_str)
    }
    
    class func showAlert(viewController: UIViewController?,title: String, msg: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)?){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(defaultAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showQAlert(viewController: UIViewController?,title: String, msg: String, handler: ((UIAlertAction) -> Swift.Void)?){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Yes", style: .default, handler: handler)
        alertController.addAction(defaultAction)
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
}
