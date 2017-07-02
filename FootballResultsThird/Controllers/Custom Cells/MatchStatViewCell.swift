//
//  MatchStatViewCell.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 23/06/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class MatchStatViewCell: UITableViewCell {

    
    @IBOutlet weak var matchStatHome: UILabel!
    @IBOutlet weak var matchStatAway: UILabel!
    
    @IBOutlet weak var matchVisualHome: StatViewLine!
    @IBOutlet weak var matchVisualAway: StatViewLine!
    
    @IBOutlet weak var matchStatEvent: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureS(_ matchStats: MatchStats) {
        
        matchStatEvent.text = matchStats.statEvent
        matchStatHome.text = matchStats.teamHome
        matchStatAway.text = matchStats.teamAway
        
        matchVisualHome.number = CGFloat(Int(matchStats.teamHome)!)
        matchVisualHome.leftSide = true
        matchVisualHome.numberOverall = CGFloat(matchStats.overalNumber)
        
        matchVisualAway.number = CGFloat(Int(matchStats.teamAway)!)
        matchVisualAway.numberOverall = CGFloat(matchStats.overalNumber)
       
//        matchVisualHome.setNeedsDisplay()
//        matchVisualAway.setNeedsDisplay()
        
    }

}
