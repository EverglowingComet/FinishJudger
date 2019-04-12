//
//  MatchItemCell.swift
//  FinishJudger
//
//  Created by MacMaster on 4/11/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit

class MatchItemCell: UITableViewCell {

    
    @IBOutlet weak var table_Cell: UIView!
    @IBOutlet weak var title_Text: UILabel!
    @IBOutlet weak var length_text: UILabel!
    @IBOutlet weak var heat_Text: UILabel!
    @IBOutlet weak var round_number: UILabel!
    @IBOutlet weak var finish_Line: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
