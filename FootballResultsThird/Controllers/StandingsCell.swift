//
//  StandingsCell.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 22/05/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class StandingsCell: UITableViewCell {
    
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var playedGames: UILabel!
    
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var losses: UILabel!
    @IBOutlet weak var draws: UILabel!
    
    @IBOutlet weak var goalsScored: UILabel!
    @IBOutlet weak var goalsAgainst: UILabel!
    @IBOutlet weak var goalsDifference: UILabel!
    
    @IBOutlet weak var points: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillingTable(_ teamsStandings: TeamsStandings) {
    
        position.text = teamsStandings.position
        //teamName.text = teamsStandings.teamName
        
        playedGames.text = teamsStandings.playedGames
        
        wins.text = teamsStandings.wins
        draws.text = teamsStandings.draws
        losses.text = teamsStandings.losses
        
        goalsScored.text = teamsStandings.goals
        goalsAgainst.text = teamsStandings.goalsAgainst
        goalsDifference.text = teamsStandings.goalDifference
        
        points.text = teamsStandings.points
    
    }

}
