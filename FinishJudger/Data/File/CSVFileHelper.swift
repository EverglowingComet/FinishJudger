//
//  CSVFileHelper.swift
//  FinishJudger
//
//  Created by Comet on 3/26/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import Foundation

class CSVFileHelper {
    var fileURL : URL
    
    var match_infos : [Match] = []
    
    init(file: URL) {
        fileURL = file
    }
    
    func readCSVContents() -> [Match] {
        var readString : String = "#Legends 100 m,1,1,,\n112,1,Usain,Bolt,Jamaica\n188,2,Carl,Lewis,USA\n192,3,Linford,Christie,UK\n176,4,Hasely,Crawford,Trinidad\n164,5,Bob,Hayes,USA\n172,6,Valeriy,Borzov,USSR\n136,7,Jesse,Owens,USA\n124,8,Harold,Abrahams,UK\n-,,,,\n#Legends 100 m,2,1,,\n212,1,Shelly-Ann,Fraser-Pryce,Jamaica\n216,2,Elaine,Thompson,Jamaica\n296,3,Gail,Devers,USA\n284,4,Evelyn,Ashford,USA\n280,5,Lyudmila,Kondratyeva,USSR\n268,6,Wyoma,Tyus,USA\n260,7,Wilma,Rudolph,USA\n248,8,Fanny,Blankers-Koen,NED\n"
        /*do {
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed to read content json file")
            print(error)
            return []
        }*/
        
        var lines: [Substring] = readString.split(separator: "\n")
        
        var i: Int = 0;
        repeat {
            if lines[i].starts(with: "#") {
                var parts = lines[i].split(separator: ",")
                if (parts.count != 5) {
                    print("Error reading CSV")
                    return []
                }
//                var match = Match(id: String(parts[0]), record_date: Date(timeIntervalSince1970: 0), title: String(parts[0]), length: Int(parts[1])!, heat: Int(parts[2])!, round: Int(parts[3])!)
//                i += 1
//                
//                while (lines[i].starts(with:  "#") == false) {
//                    var player_parts = lines[i].split(separator: ",")
//                    if (player_parts.count != 5) {
//                        print("Error reading CSV")
//                        return []
//                    }
//                    var player = Player(number: Int(player_parts[0])!, lane_number: Int(player_parts[1])!, first_name: String(player_parts[2]), last_name: String(player_parts[2]), origin: String(player_parts[4]))
//                    
//                    match.players.append(player)
//                    i += 1
//                }
//                match_infos.append(match)
            }
        } while (i < lines.count)
        return match_infos
    }
}
