//
//  Competition.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 12/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation

enum Competition: String {
   
    case PD = "http://api.football-data.org/v1/competitions/436"
    case EP = "http://api.football-data.org/v1/competitions/426"
    case SA = "http://api.football-data.org/v1/competitions/438"
    case FL1 = "http://api.football-data.org/v1/competitions/434"
    case BL1 = "http://api.football-data.org/v1/competitions/430"
    case CL = "http://api.football-data.org/v1/competitions/440"
    
    var name: String {
        
        switch self {
        case .PD:
            return "🇪🇸 Primera Division 2016/2017"
        case .SA:
            return "🇮🇹 Serie A 2016/2017"
        case .EP:
            return "🇬🇧 Premier League 2016/2017"
        case .FL1:
            return "🇫🇷 Ligue 1 2016/2017"
        case .BL1:
            return "🇩🇪 Bundesliga 2016/2017"
        case .CL:
            return "🇪🇺 Champions League 2016/2017"
       
        }
    }
    
}
