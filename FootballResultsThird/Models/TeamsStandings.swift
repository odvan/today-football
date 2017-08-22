//
//  StandingsTable.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 22/05/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation

struct TeamsStandings {
    
    let position: String
    let teamName: String
    let playedGames: String
    let wins: String
    let draws: String
    let losses: String
    let goals: String
    let goalsAgainst: String
    let goalDifference: String
    let points: String

    init(position: String,
         teamName: String,
         playedGames: String,
         wins: String,
         draws: String,
         losses: String,
         goals: String,
         goalsAgainst: String,
         goalDifference: String,
         points: String) {
        
        self.position = position
        self.teamName = teamName
        self.playedGames = playedGames
        self.wins = wins
        self.draws = draws
        self.losses = losses
        self.goals = goals
        self.goalsAgainst = goalsAgainst
        self.goalDifference = goalDifference
        self.points = points
    }
}

extension TeamsStandings {
    
    init?(json: [String : Any]) {
        
        guard let position = json["position"] as? Int,
            let teamName = json["teamName"] as? String,
            
            let playedGames = json["playedGames"] as? Int,
            let wins = json["wins"] as? Int,
            let draws = json["draws"] as? Int,
            let losses = json["losses"] as? Int,
            
            let goals = json["goals"] as? Int,
            let goalsAgainst = json["goalsAgainst"] as? Int,
            let goalDifference = json["goalDifference"] as? Int,
            let points = json["points"] as? Int
            
            else {
                return nil
        }
        
        self.position = String(position)
        self.teamName = teamName
        self.playedGames = String(playedGames)
        self.wins = String(wins)
        self.draws = String(draws)
        self.losses = String(losses)
        self.goals = String(goals)
        self.goalsAgainst = String(goalsAgainst)
        self.goalDifference = String(goalDifference)
        self.points = String(points)

    }
    
    // MARK: Method for fetching teams standings
    
    static func fetchingStandings(for league: String, completion: @escaping ([TeamsStandings]) -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let leagueTablePath = "/leagueTable"
        
        guard let url = URL(string: league + leagueTablePath)
            else { return }
        
        var urlRequestStandings = URLRequest(url: url)
        urlRequestStandings.setValue(Config.token, forHTTPHeaderField: "X-Auth-Token")
        
        Config.session.dataTask(with: urlRequestStandings) { (data, response, error) in
            
            print("✅✅✅ standings response: \(response!)")
            
            var teamsStandings: [TeamsStandings] = []
            
            guard let data = data else { return }
            
            if let jsonStandings = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any] {
                
                guard let standings = jsonStandings["standing"] as? [[String : Any]] else {
                    print("standings error")
                    completion(teamsStandings)
                    return }
                
                for standing in standings {
                    
                    if let teamStanding = TeamsStandings(json: standing) {
                        teamsStandings.append(teamStanding)
                        print("we standing there")
                    }
                }
            }
            
            completion(teamsStandings)
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            }.resume()
    }
}
