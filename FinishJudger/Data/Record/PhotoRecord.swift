//
//  PhotoRecord.swift
//  FinishJudger
//
//  Created by Comet on 3/20/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import Foundation

class PhotoRecord {
    var title: String!
    var fileName: String!
    var baseline_time_cseconds: Int = 0
    
    init(title: String!, fileName: String!, baseline_time_cseconds: Int) {
        self.title = title
        self.fileName = fileName
        self.baseline_time_cseconds = baseline_time_cseconds
    }
}
