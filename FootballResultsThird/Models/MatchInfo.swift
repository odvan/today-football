//
//  MatchInfo.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 24/06/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation

enum Event: String {
    
    case goal = "⚽️"
    case booked = "📒"
    case sentOff = "📕"
}

struct MatchInfo {
    
    let minute: String
    let score: String?
    let event: String
    let homePlayer: String?
    let awayPlayer: String?
    
    init(minute: String, score: String?, event: Event, homePlayer: String?, awayPlayer: String?) {
        
        self.minute = minute
        self.score = score
        self.event = event.rawValue
        self.homePlayer = homePlayer
        self.awayPlayer = awayPlayer
    }
}
