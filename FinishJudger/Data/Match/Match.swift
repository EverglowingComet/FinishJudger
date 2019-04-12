//
//  Match.swift
//  FinishJudger
//
//  Created by Comet on 3/20/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import Foundation

class Match {
    
    var id : String!
    var record_date : Date!
    var title : String!
    var length : Int = 0
    var heat : Int = 1
    var round : Int = 1
    var players : [Player] = []
    
    init(id: String, record_date: Date!, title: String!, length: Int, heat: Int, round: Int) {
        self.id = id
        self.record_date = record_date
        self.title = title
        self.length = length
        self.heat = heat
        self.round = round
    }
    
    func toJSON() -> String {
        var json = "{"
        json = json + "\"id\":\"" + id + "\","
        json = json + "\"record_date\":\"" + Utils.getDateTimeString(from: record_date) + "\","
        json = json + "\"title\": \"" + title + "\" ,"
        json = json + "\"length\":" + String(length) + ", "
        json = json + "\"heat\":" + String(heat) + ","
        json = json + "\"round\":" + String(round) + ","
        json = json + "\"players\":["
        for i in 0 ... players.count - 1 {
            json = json + players[i].toJSON() + (i != players.count - 1 ? "," : "]}")
        }
        return json
    }
    
    func saveToStorage(video_id: String) {
        do {
            try toJSON().write(to: URL(fileURLWithPath: Utils.getMatchFilePath(match_id: video_id)), atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print(error)
        }
    }
    
    class func from(file_id: String) -> Match? {
        if FileManager.default.fileExists(atPath: Utils.getMatchFilePath(match_id: file_id)) {
            if let str = try? String(contentsOf: URL(fileURLWithPath: Utils.getMatchFilePath(match_id: file_id)), encoding: String.Encoding.utf8) {
                
                return from(str: str)
            }
        }
        return nil
    }
    
    class func from(str: String) -> Match? {
        if let data = str.data(using: String.Encoding.utf8) {
            
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                do {
                    let id = dictionary["id"] as! String
                    let date = Utils.getDateTime(from: dictionary["record_date"] as! String)
                    let title = dictionary["title"] as! String
                    let length = dictionary["length"] as! Int
                    let heat = dictionary["heat"] as! Int
                    let round = dictionary["round"] as! Int
                    
                    let match = Match(id: id, record_date: date, title: title, length: length, heat: heat, round: round)
                    
                    let players = dictionary["players"] as! [String]
                    for player in players {
                        if let ply = Player.from(str: player) {
                            match.players.append(ply)
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
    
    class func getSampleMatch() -> Match {
        let sample = Match(id: "2019-04-04_13-45-12", record_date: Date(), title: "Boys 200m Sprint", length: 200, heat: 2, round: 3)
        sample.players.append(Player(number: 23, lane_number: 1, first_name: "Bill", last_name: "Wales", origin: "England"))
        sample.players.append(Player(number: 12, lane_number: 2, first_name: "Kane", last_name: "Arthor", origin: "Wales"))
        sample.players.append(Player(number: 3, lane_number: 3, first_name: "Kate", last_name: "Q", origin: "Sweden"))
        sample.players.append(Player(number: 5, lane_number: 4, first_name: "Usain", last_name: "Bolt", origin: "Jermakar"))
        sample.players.append(Player(number: 6, lane_number: 5, first_name: "Tom", last_name: "Hagg", origin: "Argentina"))
        return sample
    }
}
