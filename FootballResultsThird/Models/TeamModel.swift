//
//  TeamModel.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 22/06/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation

// MARK: Team Model

struct Team {
    
    let name: String
    let shortName: String
    let logoURL: String
    
    init(teamName: String, teamShortName: String, teamLogoURL: String) {
        
        self.name = teamName
        self.shortName = teamShortName
        self.logoURL = teamLogoURL
    }
    
}

extension Team {
    
    init?(json: [String : Any]) {
        
        guard let name = json["name"] as? String else { return nil }
        let teamLogo = json["crestUrl"] as? String ?? ""
        var shortName = json["shortName"] as? String ?? name
        if shortName == "" {
            shortName = name
        }
        
        self.name = name
        self.shortName = shortName
        self.logoURL = teamLogo
    }
    
    // MARK: Method for fetching teams data
    
    static func fetchTeamsInfo(competitionURL: String, completion: @escaping ([String : Team]) -> ()) {
        
        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
        guard let url = URL(string: competitionURL)
            else { return }
        
        var urlRequestInside = URLRequest(url: url)
        urlRequestInside.setValue(Config.token, forHTTPHeaderField: "X-Auth-Token")
        
        let taskFetchingTeams = Config.session.dataTask(with: urlRequestInside) { (data, response, error) in
            
            print("🔶 \(response!)")
            
            var teamsDict: [String : Team] = [:]
            
            guard let data = data else { return }
            
            //            if error != nil {
            //                print(error!)
            //                return
            //            } else {
            //                let responceActual = response
            //                //print(responceActual!)
            //            }
            
            if let jsonTeams = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any] {
                
                guard let teamsFrom = jsonTeams["teams"] as? [[String : Any]] else {
                    print("Can't parse teams JSON info")
                    return }
                
                for team in teamsFrom {
                    
                    if let teamDict = Team(json: team) {
                        
                        teamsDict[teamDict.name] = teamDict
                    }
                }
                completion(teamsDict)
            }
        }
        taskFetchingTeams.resume()
    }
}
