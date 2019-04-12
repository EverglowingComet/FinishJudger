//
//  PlayerInfoItemCell.swift
//  FinishJudger
//
//  Created by MacMaster on 4/11/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit

class PlayerInfoItemCell: UITableViewCell {

    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var originText: UILabel!
    @IBOutlet weak var numberText: UILabel!
    @IBOutlet weak var laneNumberText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
