//
//  CameraRecordItem.swift
//  FinishJudger
//
//  Created by MacMaster on 4/9/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit

class CameraRecordItem: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var wrpper: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
