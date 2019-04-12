//
//  MatchesViewController.swift
//  FinishJudger
//
//  Created by MacMaster on 4/11/19.
//  Copyright © 2019 Comet. All rights reserved.
//

import UIKit

class MatchesViewController: UIViewController {
    
    var matches: [Match]!
    var selectedMatch: Match!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension MatchesViewController : UITableViewDelegate {
    
}

//extension MatchesViewController : UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//}
