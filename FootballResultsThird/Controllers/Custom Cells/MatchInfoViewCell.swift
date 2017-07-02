//
//  MatchInfoViewCell.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 23/06/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class MatchInfoViewCell: UITableViewCell {

    @IBOutlet weak var matchEvent: UILabel!
    @IBOutlet weak var matchEventMinute: UILabel!
    
    @IBOutlet weak var matchEventHomePlayer: UILabel!
    @IBOutlet weak var matchEventAwayPlayer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureI(_ matchInfo: MatchInfo) {
        
        matchEventMinute.text = matchInfo.minute
        matchEvent.text = matchInfo.score ?? ""
      
        if matchInfo.homePlayer != nil {
            matchEventHomePlayer.text = matchInfo.homePlayer! + " \(matchInfo.event)"
            matchEventAwayPlayer.text = ""
        } else {
            matchEventHomePlayer.text = ""
            matchEventAwayPlayer.text = "\(matchInfo.event) " + matchInfo.awayPlayer!
        }
    }
    
}
