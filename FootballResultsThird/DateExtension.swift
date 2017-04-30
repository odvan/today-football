//
//  DateExtension.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 04/04/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation

extension Date {
    
    // Method for computing game status
    
    static func gameStatus(date: String?, status: Game) -> String? {
        
        switch status {
        case .scheduled, .timed, .error:
            if let string = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" //2017-03-05T11:00:00Z
                
                let fixtureDateInput = formatter.date(from: string)!
                
                formatter.dateFormat = "HH:mm"
                let fixtureDateOutput = formatter.string(from: fixtureDateInput)
                
                return fixtureDateOutput
            }
        case .inPlay:
            // API doesn't provide exactly game duration time (compensated time to each half), so this is row calculation
            if let string = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                
                let fixtureDateInput = formatter.date(from: string)!
                
                let timeInterval: Double = abs(round(fixtureDateInput.timeIntervalSinceNow))
                
                switch timeInterval {
                    
                case 0...2700:
                    return "\(UInt(timeInterval / 60))'"
                    
                    
                case 2701...3600:
                    return "Half Time"
                    
                case 3600...6300:
                    return "\(UInt((timeInterval - 900) / 60))'"
                    
                case 6300...6900:
                    return "90+'"
                    
                case 6900...8700:
                    return "\(UInt((timeInterval - 1200) / 60))'"
                    
                default:
                    return "Unknown"
                    
                }
            }
            
        case .finished:
            return "Full Time"
        case .postponed:
            return "Postponed"
        case .cancelled:
            return "Cancelled"
        }
        
        return nil
    }
    
    // Method for translating dates into API url request

    static func gameFixture(timeInterval: Double?) -> String {
        let today = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let interval = timeInterval {
            let otherDate = today.addingTimeInterval(interval)
            let fixtureDateOutput = formatter.string(from: otherDate)
            print("🔵 yesterday/tomorrow: \(fixtureDateOutput)")
            return "timeFrameStart=\(fixtureDateOutput)&timeFrameEnd=\(fixtureDateOutput)"
            
            
        } else {
            let fixtureDateOutput = formatter.string(from: today)
            print("🔵 today: \(fixtureDateOutput)")
            return "timeFrameStart=\(fixtureDateOutput)&timeFrameEnd=\(fixtureDateOutput)"
            
        }
    }
    
    // Method for formatting dates for segmented control tabs titles

    static func forTabs(timeInterval: Double?) -> String {
        let today = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        if let interval = timeInterval {
            let otherDate = today.addingTimeInterval(interval)
            let setDateForTitle = formatter.string(from: otherDate)
            print("❎ yesterday/tomorrow: \(setDateForTitle)")
            return setDateForTitle
            
        } else {
            let setDateForTitle = formatter.string(from: today)
            print("❎ today: \(setDateForTitle)")
            return setDateForTitle
            
        }

    }
}
