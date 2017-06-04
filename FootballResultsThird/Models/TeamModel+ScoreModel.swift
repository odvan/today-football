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
    case error = ""
    case afterExtraTime = "AET"
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

enum Penalty: String {
    case homeWonBy
    case awayWonBy
}

struct Score {
    
    let gameStatus: Game
    let gameResult: String
    let homeTeam: String
    let awayTeam: String
    
    let date: String
    
    let competition: Competition
    let competitionTeamsURL: String
    
    let odds: String
    let penalty: Penalty?
    
    init(gameStatus: Game, gameResult: String, homeTeam: String, awayTeam: String, date: String, competition: String, odds: String, penalty: Penalty?) {

        self.gameStatus = gameStatus
        self.gameResult = gameResult
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        
        self.date = date
        
        self.competition = Competition(rawValue: competition)!
        self.competitionTeamsURL = competition + "/teams"
        
        self.odds = odds
        
        self.penalty = penalty
    }
    
}

extension Score {
    
    init?(json: [String : Any]) {
        
        let homeTeam = json["homeTeamName"] as? String ?? ""
        let awayTeam = json["awayTeamName"] as? String ?? ""
        let date = json["date"] as? String ?? ""
        var gameStatus = json["status"] as? String ?? ""
        
        let result = json["result"] as? [String : Any]
        var homeGoals = result?["goalsHomeTeam"] as? Int ?? 0
        var awayGoals = result?["goalsAwayTeam"] as? Int ?? 0
        
        if let extraTime = result?["extraTime"] as? [String : Int] {
            homeGoals = extraTime["goalsHomeTeam"] ?? 0
            awayGoals = extraTime["goalsAwayTeam"] ?? 0
            gameStatus = "AET"
        }
        
        var penalty: Penalty?

        if let penaltyHappened = result?["penaltyShootout"] as? [String : Int] {
            let homePenalty = penaltyHappened["goalsHomeTeam"]!
            let awayPenalty = penaltyHappened["goalsAwayTeam"]!
            
            if homePenalty > awayPenalty {
                penalty = Penalty.homeWonBy
            } else {
                penalty = Penalty.awayWonBy
            }

        }
    
        
        guard let links = json["_links"] as? [String : Any],
            let competition = links["competition"] as? [String : String],
            let competitionURL = competition["href"]
            else { return nil }
        
        let odds = json["odds"] as? [String : Double]
        let homeWin = odds?["homeWin"] ?? 0
        let draw = odds?["draw"] ?? 0
        let awayWin = odds?["awayWin"] ?? 0
        
        self.gameStatus = Game(rawValue: gameStatus)!
        self.gameResult = "\(homeGoals) - \(awayGoals)"
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.date = date
        self.competition = Competition(rawValue: competitionURL)!
        self.competitionTeamsURL = competitionURL + "/teams"
        self.odds = "Home: \(homeWin) ● Draw: \(draw) ● Away: \(awayWin)"
        
        self.penalty = penalty
    }
}
