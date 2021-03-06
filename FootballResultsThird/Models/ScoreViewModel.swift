//
//  ScoreViewModel.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 07/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation

struct ScoreViewModel {
    
    let gameStatus: Game
    let gameResult: String
    let gameHTResult: String?
    let homeTeam: String
    let awayTeam: String
    
    let date: String
    
    let competition: Competition
    let competitionTeamsURL: String
    
    let matchDay: String
    
    let odds: String
    
    let penalty: Penalty?
    
    init(score: Score) {
        
        gameStatus = score.gameStatus
        gameResult = score.gameResult
        gameHTResult = score.gameHTResult
        homeTeam = score.homeTeam
        awayTeam = score.awayTeam
        
        matchDay = score.matchDay
        date = score.date
        
        competition = score.competition
        competitionTeamsURL = score.competitionTeamsURL
        odds = score.odds
        penalty = score.penalty
    }
}
