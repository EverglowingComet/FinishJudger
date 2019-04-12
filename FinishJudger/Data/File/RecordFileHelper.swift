//
//  RecordFileHelper.swift
//  FinishJudger
//
//  Created by Comet on 3/26/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import Foundation

class RecordFileHelper {
    var topPath : URL
    var recordingId : String
    var content_json : URL
    
    var videofiles : [URL] = []
    
    init(path: URL?, item_id: String!) {
        if path == nil {
            let DocumentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            topPath = DocumentURL.appendingPathComponent("finish_judger", isDirectory: true)
        } else {
            topPath = path!
        }
        recordingId = item_id
        content_json = topPath.appendingPathComponent(recordingId, isDirectory: true).appendingPathComponent("contents", isDirectory: false).appendingPathExtension("json")
    }
    
    func createVideoURL(video_id: String!) -> URL {
        return topPath.appendingPathComponent(recordingId, isDirectory: true).appendingPathComponent(video_id, isDirectory: false).appendingPathExtension("mp4")
    }
    
    func addVideoURL(video_item : URL) {
        videofiles.append(video_item)
    }
    
    func removeVideo(video_item : URL) {
        for i in 0...videofiles.count {
            if video_item == videofiles[i] {
                videofiles.remove(at: i)
                try! FileManager.default.removeItem(at: video_item)
            }
        }
    }
    
    func readContentJson() -> String {
        var readString : String = ""
        do {
            readString = try String(contentsOf: content_json)
        } catch let error as NSError {
            print("Failed to read content json file")
            print(error)
        }
        return readString
    }
    
    func writeContentJson(content : String!) -> Bool {
        do {
            try content.write(to: content_json, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch let error as NSError {
            print("Failed to write content json file")
            print(error)
            return false
        }
    }
}
