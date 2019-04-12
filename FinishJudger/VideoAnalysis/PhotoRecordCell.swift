//
//  PhotoRecordCell.swift
//  FinishJudger
//
//  Created by Comet on 3/20/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit

class PhotoRecordCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
