//
//  VideoRecord.swift
//  FinishJudger
//
//  Created by Comet on 3/20/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import Foundation

class VideoRecord {
    var title: String!
    var fileURL: URL!
    var record_date: NSDate!
    var record_start_cseconds: Int = 0
    var photoRecords: [PhotoRecord] = []
    
    var breakpoint_cseconds: [Int] = []
    
    init(title: String!, fileURL: URL!, record_date: NSDate!, record_start_cseconds: Int) {
        self.title = title
        self.fileURL = fileURL
        self.record_date = record_date
        self.record_start_cseconds = record_start_cseconds
    }
    
    func setPhotoRecords(records: [PhotoRecord]) {
        photoRecords = records
    }
    
    func clearBreakPoints() {
        breakpoint_cseconds.removeAll()
    }
    
    func appendBreakPoints(point: Int) -> [Int] {
        breakpoint_cseconds.append(point)
        return breakpoint_cseconds
    }
    
    func getBreakPoints() -> [Int] {
        return breakpoint_cseconds
    }
}
