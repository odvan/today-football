//
//  Constants.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 06/07/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import Foundation


struct Config {

    static let token = "7dc5b5f70135455b9c5e1677c33920d2"
    static let session = URLSession.shared

}

// Global keys for UserDefaults settings
struct GlobalKey {
    
    static let selectedCompetitonsForUrlPath = "Competitions selected for URL path"
    static let selectedForSVC = "Competitions selected for Settings VC"
}
