//
//  TeamModel.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 05/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation

// MARK: Game status enum

enum Game: String {
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
    case inPlay = "IN_PLAY"
    case finished = "FINISHED"
    case postponed = "POSTPONED"
    case cancelled = "CANCELED"
 }

// MARK: Team Model

struct Team {
    
    let shortName: String
    let logoURL: String
    
    init(teamName: String, teamLogoURL: String) {
        
        self.shortName = teamName
        self.logoURL = teamLogoURL
    }
    
}

// MARK: Fixture Model

struct Score {
    
    let gameStatus: Game
    let gameResult: String
    let homeTeam: String
    let awayTeam: String
    
    let date: String
    
    let competition: Competition
    let competitionTeamsURL: String
    
    let odds: String
    
    init(gameStatus: Game, gameResult: String, homeTeam: String, awayTeam: String, date: String, competition: String, odds: String) {

        self.gameStatus = gameStatus
        self.gameResult = gameResult
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        
        self.date = date
        
        self.competition = Competition(rawValue: competition)!
        self.competitionTeamsURL = competition + "/teams"
        
        self.odds = odds
    }
    
}
