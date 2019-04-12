//
//  VideoItemCell.swift
//  FinishJudger
//
//  Created by MacMaster on 4/10/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit

class VideoItemCell: UITableViewCell {

    @IBOutlet weak var video_time_span: UILabel!
    @IBOutlet weak var video_file_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
