//
//  MatchBigInfoCell.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 02/07/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class MatchBigInfoCell: UITableViewCell {
    
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var liveGameSign: PaddedLabel!
    @IBOutlet weak var scoreLabel: PaddedLabel!
    @IBOutlet weak var scoreHTLabel: UILabel!
   
    @IBOutlet weak var homeTeamLogo: CustomImageView!
    @IBOutlet weak var awayTeamLogo: CustomImageView!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureMatchDetails(_ scoreModel: ScoreViewModel) {
        
        gameStatus.text = Date.gameStatus(date: scoreModel.date, status: scoreModel.gameStatus)
        
        if scoreModel.gameStatus == .inPlay {
            liveGameSign.alpha = 1.0
        }
       
        scoreLabel.text = scoreModel.gameResult
        if (scoreModel.gameHTResult != nil) {
            scoreHTLabel.text = scoreModel.gameHTResult
        } else {
            scoreHTLabel.isHidden = true
        }
        

    }


}
