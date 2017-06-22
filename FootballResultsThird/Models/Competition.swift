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
    case PL = "http://api.football-data.org/v1/competitions/426"
    case SA = "http://api.football-data.org/v1/competitions/438"
    case FL1 = "http://api.football-data.org/v1/competitions/434"
    case BL1 = "http://api.football-data.org/v1/competitions/430"
    case CL = "http://api.football-data.org/v1/competitions/440"
    
    case FAC = "http://api.football-data.org/v1/competitions/429"
    
    var name: String {
        
        switch self {
        case .PD:
            return "🇪🇸 Primera Division 2016/2017"
        case .SA:
            return "🇮🇹 Serie A 2016/2017"
        case .PL:
            return "🇬🇧 Premier League 2016/2017"
        case .FL1:
            return "🇫🇷 Ligue 1 2016/2017"
        case .BL1:
            return "🇩🇪 Bundesliga 2016/2017"
        case .CL:
            return "🇪🇺 Champions League 2016/2017"
            
        case .FAC:
            return "FA Cup 2016/2017"
       
        }
    }
    
    // MARK: Creating string path for API Url from selected competitions
    
    static func creatingStringForUrlPath(from competitions: [String]) -> String {
        
        var stringFromComp: String = ""
        
        for competition in competitions {
            
            var compIndex: String {
                
                switch competition {
                case Competition.PD.name:
                    return "PD,"
                case Competition.SA.name:
                    return "SA,"
                case Competition.BL1.name:
                    return "BL1,"
                case Competition.FL1.name:
                    return "FL1,"
                case Competition.PL.name:
                    return "PL,"
                case Competition.CL.name:
                    return "CL,"
                    
                case Competition.FAC.name:
                    return "FAC,"
                    
                default:
                    return "Error"
                }
            }

        stringFromComp += compIndex
    }
    stringFromComp.characters.removeLast()
    
    print("🆔🆔🆔 selected comp string: \(stringFromComp)")
    return stringFromComp
}
    
}
