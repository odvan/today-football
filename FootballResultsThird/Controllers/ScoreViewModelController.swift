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
    let demoURL = "http://api.football-data.org/v1/fixtures/?timeFrameStart=2017-05-20&timeFrameEnd=2017-05-20&league="
    let baseURL = "http://api.football-data.org/v1/fixtures/?league="
    let demoSummerURL = "http://api.football-data.org/v1/competitions/436/fixtures/?timeFrameStart=2017-05-19&timeFrameEnd=2017-05-30"
    
    /* "BL1,PD,PL,SA,FL1,CL&"
     //?league=BL1,PL,SA,PD,FL1,CL&timeFrameStart=2017-05-20&timeFrameEnd=2017-05-20
     FAC: http://api.football-data.org/v1/competitions/429/fixtures/?timeFrameStart=2016-11-14&timeFrameEnd=2016-11-14

     */
    
    fileprivate var scoreModels: [ScoreViewModel?] = []
    var teamsDictGlobal: [String : Team] = [:]
    var competitionsToday: [String] = [""] // need initialize, will fix it later
    var competitionsLinks: [String] = []
    var allCompetitions: [String] = [] // for caching competitions from all three days
    var competitionsSorted: [String : [ScoreViewModel]] = [:]
    
    
    // MARK: Main method for fetching data
    
    func retrieveScores(from date: String, and competitions: String, _ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let url = URL(string: baseURL + competitions + date) else { //demoURL + competitions  ///baseURL + competitions + date
            completionBlock(false, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(Config.token, forHTTPHeaderField: "X-Auth-Token")
        
        let task = Config.session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
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
                
                print("⚠️ game counts: \(fixturesFrom.count)")
                var scores = [Score?]()
                var competitions: [String] = []
                var links: [String] = []

                let group = DispatchGroup()
                let syncQueue = DispatchQueue(label: "com.domain.app.teams")
                let finishQueue = DispatchQueue(label: "com.domain.app.finish", qos: .userInitiated) //, attributes: .concurrent)
                
                for fixture in fixturesFrom {
                    
//                    if let score = ScoreViewModelController.parse(fixture) {
                    if let score = Score(json: fixture) {

                        scores.append(score)

                        if competitions.count == 0 || !competitions.contains(score.competition.name) {
                            
                            competitions.append(score.competition.name)
                            links.append(score.competition.rawValue)
                            
                        }
                        if strongSelf.allCompetitions.count == 0 || !strongSelf.allCompetitions.contains(score.competition.name) {
                            
                            strongSelf.allCompetitions.append(score.competition.name)

                            group.enter()
                            Team.fetchTeamsInfo(competitionURL: score.competitionTeamsURL) { teamsDict in
                                
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
                    strongSelf.competitionsLinks = links
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

// MARK: Passing score model into scoreViewModel (according to MVVC architecture)

private extension ScoreViewModelController {
    
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
