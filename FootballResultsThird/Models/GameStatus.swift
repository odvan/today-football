//
//  GameStatus.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 22/06/17.
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

