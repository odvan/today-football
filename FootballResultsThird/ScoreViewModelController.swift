//
//  ScoreViewModelController.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 10/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation


class ScoreViewModelController {
    
    // MARK: Constants & Variables

    let baseURL = "http://api.football-data.org/v1/fixtures/?league=BL1,PL,SA,PD,FL1,CL&"
    //let token =
    let session = URLSession.shared
    
    fileprivate var scoreModels: [ScoreViewModel?] = []
    var teamsDictGlobal: [String : Team] = [:]
    var competitionsToday: [String] = [""] // need to initialize with empty string to prevent appearing "no scheduled games" for a fraction of time
    var allCompetitions: [String] = [] // for caching competitions from all three days
    var competitionsSorted: [String : [ScoreViewModel]] = [:]
    
    
    // MARK: Main method for fetching data
    
    func retrieveScores(from date: String, _ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let url = URL(string: baseURL + date) else {
            completionBlock(false, nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        //urlRequest.setValue(token, forHTTPHeaderField: "X-Auth-Token")
        
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            print("⭕️ main response: \(response!)")
            guard let strongSelf = self else { return }
            guard let data = data else {
                completionBlock(false, error as NSError?)
                return
            }
            
//            let error = NSError.createError(0, description: "JSON parsing error")
            
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                
                guard let fixturesFrom = jsonData?["fixtures"] as? [[String : Any]] else {
                    completionBlock(false,  error as NSError?)
                    return
                }
                
                var scores = [Score?]()
                var competitions: [String] = []

                let group = DispatchGroup()
                let syncQueue = DispatchQueue(label: "com.domain.app.teams")
                let finishQueue = DispatchQueue(label: "com.domain.app.finish", qos: .userInitiated)
                
                for fixture in fixturesFrom {
                    
                    if let score = ScoreViewModelController.parse(fixture) {
                        scores.append(score)

                        if competitions.count == 0 || !competitions.contains(score.competition.name) {
                            
                           competitions.append(score.competition.name)
                            
                        }
                        if strongSelf.allCompetitions.count == 0 || !strongSelf.allCompetitions.contains(score.competition.name) {
                            
                            strongSelf.allCompetitions.append(score.competition.name)

                            group.enter()
                            strongSelf.fetchTeamsInfo(competitionURL: score.competitionTeamsURL) { teamsDict in
                                
                                syncQueue.async {
                                    let teamsInfo = teamsDict
                                    teamsInfo.forEach { (k,v) in strongSelf.teamsDictGlobal[k] = v }
                                    //self.teamsDictGlobal = teamsInfo
                                    
                                    print("teams dictionary: \(teamsInfo)")
                                    group.leave()
                                }
                            }
                        }
                    }
                    
                }
                
                group.notify(queue: finishQueue) {
                    print("comp today: \(competitions)")
                    strongSelf.competitionsToday = competitions
                    strongSelf.scoreModels = ScoreViewModelController.initViewModels(scores)
                    strongSelf.competitionsSorted = strongSelf.sortScoresForTable(competitionsToday: competitions, scoresToday: strongSelf.scoreModels as! [ScoreViewModel])

                    completionBlock(true, nil)
                }
                
            } else {
                completionBlock(false, error as NSError?)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

        }
        task.resume()
    }
    
    // MARK: Method and variables for checking fixture index in the table
    
    var scoreModelsCount: Int {
        return scoreModels.count
    }
    
    var competitionsCount: Int {
        return competitionsSorted.count
    }
    
    func fixture(at section: Int, at index: Int) -> ScoreViewModel? {
        guard section >= 0, section < competitionsCount, index >= 0, index < scoreModelsCount
            else { return nil }
        print("competitionsCount: \(competitionsCount), section: \(section), index: \(index)")
        print("scoreModelsCount: \(competitionsSorted[competitionsToday[section]]!.count)")
        print("🔴 index: \(competitionsSorted[competitionsToday[section]]?[index])")
        return competitionsSorted[competitionsToday[section]]?[index]
    }
    
    // MARK: Method for fetching teams data
    
    func fetchTeamsInfo(competitionURL: String, completion: @escaping ([String : Team]) -> ()) {
        
        guard let url = URL(string: competitionURL)
            else { return }
        
        let urlRequestInside = URLRequest(url: url)
        //urlRequestInside.setValue(token, forHTTPHeaderField: "X-Auth-Token")
        
        let taskInside = session.dataTask(with: urlRequestInside) { (data, response, error) in
            
            print("🔶 \(response!)")
            guard let data = data else { return }
            
//            if error != nil {
//                print(error!)
//                return
//            } else {
//                let responceActual = response
//                //print(responceActual!)
//            }
            
            if let jsonTeams = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any] {
                
                guard let teamsFrom = jsonTeams["teams"] as? [[String : Any]] else { return }
                
                var teamsDict: [String : Team] = [:]
                
                for team in teamsFrom {
                    
                    guard let name = team["name"] as? String else { return }
                    let teamLogo = team["crestUrl"] as? String ?? ""
                    let shortName = team["shortName"] as? String ?? ""
                    
                    teamsDict[name] = Team(teamName: shortName, teamLogoURL: teamLogo)
                }
                
                completion(teamsDict)
                
            }
        }
        taskInside.resume()
        
    }
    
    // MARK: Method for sorting fixtures
    
    func sortScoresForTable(competitionsToday: [String], scoresToday: [ScoreViewModel]) -> [String : [ScoreViewModel]] {
        
        var sorted: [String : [ScoreViewModel]] = [:]
        
        for competition in competitionsToday {
            
            let sortScores = scoresToday.filter{ $0.competition.name == competition }
            sorted[competition] = sortScores
            
        }
        
        return sorted
    }
}

// MARK: Method for parsing JSON data into score model

private extension ScoreViewModelController {
    
    static func parse(_ json: [String: Any]) -> Score? {
        
        let homeTeam = json["homeTeamName"] as? String ?? ""
        let awayTeam = json["awayTeamName"] as? String ?? ""
        let date = json["date"] as? String ?? ""
        let gameStatus = json["status"] as? String ?? ""
        
        let result = json["result"] as? [String : Any]
        let homeGoals = result?["goalsHomeTeam"] as? Int ?? 0
        let awayGoals = result?["goalsAwayTeam"] as? Int ?? 0
        
        guard let links = json["_links"] as? [String : Any],
        let competition = links["competition"] as? [String : String],
        let competitionURL = competition["href"]
            else { return nil }
        
        let odds = json["odds"] as? [String : Double]
        let homeWin = odds?["homeWin"] ?? 0
        let draw = odds?["draw"] ?? 0
        let awayWin = odds?["awayWin"] ?? 0

        return Score(gameStatus: Game(rawValue: gameStatus)!, gameResult: "\(homeGoals) - \(awayGoals)", homeTeam: homeTeam, awayTeam: awayTeam, date: date, competition: competitionURL, odds: "Home: \(homeWin) ● Draw: \(draw) ● Away: \(awayWin)")
    }
    
    // MARK: Passing score model into scoreViewModel (according to MVVC architecture)
    
    static func initViewModels(_ scores: [Score?]) -> [ScoreViewModel?] {
        return scores.map { score in
            if let scoreInside = score {
                return ScoreViewModel(score: scoreInside)
            } else {
                return nil
            }
        }
    }
    
}

//extension NSError {
//    static func createError(_ code: Int, description: String) -> NSError {
//        return NSError(domain: "com.aprearo.TableView",
//                       code: 400,
//                       userInfo: [
//                        "NSLocalizedDescription" : description
//            ])
//    }
//}
