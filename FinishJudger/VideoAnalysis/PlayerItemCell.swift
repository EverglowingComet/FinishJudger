//
//  PlayerItemCell.swift
//  FinishJudger
//
//  Created by MacMaster on 4/10/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit

class PlayerItemCell: UITableViewCell {

    @IBOutlet weak var player_name: UILabel!
    @IBOutlet weak var player_number: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var record: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
