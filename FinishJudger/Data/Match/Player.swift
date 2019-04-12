//
//  Player.swift
//  FinishJudger
//
//  Created by Comet on 3/20/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import Foundation

class Player {
    var number = 1
    var lane_number = 1
    var first_name : String!
    var last_name : String!
    var origin : String!
    var rank = -1
    var recordsCSec = -1
    
    init(number : Int, lane_number: Int, first_name: String!, last_name: String!, origin: String!) {
        self.number = number
        self.lane_number = lane_number
        self.first_name = first_name
        self.last_name = last_name
        self.origin = origin
    }
    
    func toJSON() -> String {
        var json = "{"
        json = json + "\"number\":" + String(number) + ","
        json = json + "\"lane_number\":" + String(lane_number) + ","
        json = json + "\"first_name\":\"" + first_name + "\","
        json = json + "\"last_name\":\"" + last_name + "\","
        json = json + "\"origin\":\"" + origin + "\"}"
        return json
    }
    
    class func from(str: String) -> Player? {
        if let data = str.data(using: String.Encoding.utf8), let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] {
            do {
                
                let number = dictionary["number"] as! Int
                let lane_number = dictionary["lane_number"] as! Int
                let first_name = dictionary["first_name"] as! String
                let last_name = dictionary["last_name"] as! String
                let origin = dictionary["origin"] as! String
                
                return Player(number: number, lane_number: lane_number, first_name: first_name, last_name: last_name, origin: origin)
                
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
