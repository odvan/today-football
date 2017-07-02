//
//  MatchStats.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 01/07/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation

enum Statistics: String {
    
    case shotsOnT = "shots on target"
    case shotsOffT = "shots off target"
    case possession = "possession (%)"
    case corners = "corners"
    case offsides = "offsides"
    case fouls = "fouls"
    case yCards = "yellow cards"
    case goalK = "goal kicks"
}

struct MatchStats {
    
    let statEvent: String
    let teamHome: String
    let teamAway: String
    let overalNumber: Int
    
    init(statEvent: Statistics, teamHome: String, teamAway: String, overallNumber: Int) {
        
        self.statEvent = statEvent.rawValue
        self.teamHome = teamHome
        self.teamAway = teamAway
        self.overalNumber = Int(teamHome)! + Int(teamAway)!
    }

}
