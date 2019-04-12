//
//  MatchRecordItem.swift
//  FinishJudger
//
//  Created by MacMaster on 4/9/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import Foundation

class MatchRecordItem {
    static let RECORDING = "Recording"
    static let SAVING = "Saving"
    static let SAVED = "Saved"
    static let FAILED = "Failed"
    
    var startTimeCSeconds : Int
    var durationCSeconds = -1
    var currentStatus : String
    var filePath : String?
    
    init(startTime: Int, status: String, path: String?) {
        startTimeCSeconds = startTime
        currentStatus = status
        filePath = path
    }
    
    func toJSON() -> String {
        var json = "{"
        json = json + "\"startTimeCSeconds\":" + String(startTimeCSeconds) + ","
        json = json + "\"durationCSeconds\":" + String(durationCSeconds) + ","
        json = json + "\"currentStatus\":\"" + currentStatus + "\","
        json = json + "\"filePath\":\"" + (filePath ?? "no_path") + "\"}"
        return json
    }
    
    class func from(str: String) -> MatchRecordItem? {
        if let data = str.data(using: String.Encoding.utf8), let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] {
            do {
                
                let startTimeCSeconds = dictionary["startTimeCSeconds"] as! Int
                let durationCSeconds = dictionary["durationCSeconds"] as! Int
                let currentStatus = dictionary["currentStatus"] as! String
                let filePath = dictionary["filePath"] as! String
                
                let item = MatchRecordItem(startTime: startTimeCSeconds, status: currentStatus, path: filePath)
                item.durationCSeconds = durationCSeconds
                
                return item
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

class MatchRecordVideoData {
    var videos : [MatchRecordItem]!
    var identifier : String
    
    init(id: String, video_list: [MatchRecordItem]) {
        identifier = id
        videos = video_list
    }
    
    func toJSON() -> String {
        var json = "{"
        json = json + "\"id\":\"" + identifier + "\","
        json = json + "\"videos\":["
        for i in 0 ... videos.count - 1 {
            json = json + videos[i].toJSON() + (i != videos.count - 1 ? "," : "]}")
        }
        return json
    }
    
    func saveToStorage() {
        do {
            try toJSON().write(to: URL(fileURLWithPath: Utils.getVideoRecFilePath(match_id: identifier)), atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print(error)
        }
    }
    
    class func from(file_id: String) -> MatchRecordVideoData? {
        if FileManager.default.fileExists(atPath: Utils.getMatchFilePath(match_id: file_id)) {
            if let str = try? String(contentsOf: URL(fileURLWithPath: Utils.getVideoRecFilePath(match_id: file_id)), encoding: String.Encoding.utf8) {
                
                return from(str: str)
            }
        }
        return nil
    }
    
    class func from(str: String) -> MatchRecordVideoData? {
        if let data = str.data(using: String.Encoding.utf8) {
            
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                do {
                    let id = dictionary["id"] as! String
                    
                    let match = MatchRecordVideoData(id: id, video_list: [])
                    
                    let videos = dictionary["videos"] as! [String]
                    for reocrd in videos {
                        if let rec = MatchRecordItem.from(str: reocrd) {
                            match.videos.append(rec)
                        }
                    }
                    return match
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        return nil
    }
    
    
}
