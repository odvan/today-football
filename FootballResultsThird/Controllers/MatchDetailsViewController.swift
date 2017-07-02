//
//  MatchDetailsViewController.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 16/06/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class MatchDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var detailTable: UITableView!
    
    var score: ScoreViewModel?
    var homeLogo: String?
    var awayLogo: String?
    var homeTeamName: String?
    var awayTeamName: String?
    
    let cellFirst = "matchMainInfo"
    
    //
    /* Only for demo purpose - actual API doesn't provide match info and statistics yet */
    //
    var matchDetailsSectionsName: [String] = ["Matchweek", "Info", "Statistic"]
    let cellInfoID = "matchInfo"
    let cellStatID = "matchStats"
    
    var matchInfoArray: [MatchInfo]!
    
    let matchInfoOne: MatchInfo = MatchInfo(minute: "7'", score: "1 - 0", event: Event.goal, homePlayer: "Douglas", awayPlayer: nil)
    let matchInfoTwo: MatchInfo = MatchInfo(minute: "22'", score: "1 - 1", event: Event.goal, homePlayer: nil, awayPlayer: "Ruben Castro")
    let matchInfoThree: MatchInfo = MatchInfo(minute: "37'", score: nil, event: Event.booked, homePlayer: nil, awayPlayer: "Alvaro Cejudo")
    let matchInfoFour: MatchInfo = MatchInfo(minute: "59'", score: "1 - 2", event: Event.goal, homePlayer: nil, awayPlayer: "Ruben Castro")
    let matchInfoFive: MatchInfo = MatchInfo(minute: "79'", score: "2 - 2", event: Event.goal, homePlayer: "Carlos Carmona", awayPlayer: nil)
    let matchInfoSix: MatchInfo = MatchInfo(minute: "86'", score: nil, event: Event.booked, homePlayer: nil, awayPlayer: "Riza Durmisi")
    
    var matchStatsArray: [MatchStats]!
    
    let matchStatOne: MatchStats = MatchStats(statEvent: Statistics.shotsOnT, teamHome: "5", teamAway: "9", overallNumber: 14)
    let matchStatTwo: MatchStats = MatchStats(statEvent: Statistics.shotsOffT, teamHome: "4", teamAway: "8", overallNumber: 12)
    let matchStatThree: MatchStats = MatchStats(statEvent: Statistics.possession, teamHome: "47", teamAway: "53", overallNumber: 100)
    let matchStatFour: MatchStats = MatchStats(statEvent: Statistics.corners, teamHome: "2", teamAway: "3", overallNumber: 5)
    let matchStatFive: MatchStats = MatchStats(statEvent: Statistics.offsides, teamHome: "4", teamAway: "1", overallNumber: 5)
    let matchStatSix: MatchStats = MatchStats(statEvent: Statistics.fouls, teamHome: "15", teamAway: "14", overallNumber: 29)
    let matchStatSeven: MatchStats = MatchStats(statEvent: Statistics.yCards, teamHome: "0", teamAway: "2", overallNumber: 2)
    let matchStatEight: MatchStats = MatchStats(statEvent: Statistics.goalK, teamHome: "7", teamAway: "7", overallNumber: 14)
    
    //
    /* Only for demo purpose - actual API doesn't provide match info and statistics yet */
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        matchInfoArray = [matchInfoOne, matchInfoTwo, matchInfoThree, matchInfoFour, matchInfoFive, matchInfoSix]
        matchStatsArray = [matchStatOne, matchStatTwo, matchStatThree, matchStatFour, matchStatFive, matchStatSix, matchStatSeven, matchStatEight]
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        detailTable.reloadData()
//        detailTable.estimatedRowHeight = 30
//        detailTable.rowHeight = UITableViewAutomaticDimension
        
        if let scoreModel = score {
            matchDetailsSectionsName[0] = scoreModel.matchDay
        }
        print("💊 \(matchDetailsSectionsName)")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Table's methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return matchDetailsSectionsName.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return matchDetailsSectionsName[section]
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        header.textLabel?.textAlignment = NSTextAlignment.center
        //header.textLabel?.textColor = UIColor.white
        header.contentView.backgroundColor = UIColor(red: 102/255, green: 255/255, blue: 204/255, alpha: 1.0)
    
    }
    
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        
//        return 12
//    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return (matchInfoArray.count)
        } else {
            return (matchStatsArray.count)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 136
        } else {
            return 32
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: cellFirst, for: indexPath) as! MatchBigInfoCell
            
            cell.configureMatchDetails(score!)
            cell.homeTeam.text = homeTeamName
            cell.awayTeam.text = awayTeamName
            cell.homeTeamLogo.updateLogo(link: homeLogo)
            cell.awayTeamLogo.updateLogo(link: awayLogo)
            
            return cell
            
        }
        if indexPath.section == 1 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: cellInfoID, for: indexPath) as! MatchInfoViewCell
            
            if let info = matchInfoArray?[indexPath.row] {
                //print(info.awayPlayer ?? "no away player")
                cell.configureI(info)
            }
            return cell
            
        } else {
            let cell = detailTable.dequeueReusableCell(withIdentifier: cellStatID, for: indexPath) as! MatchStatViewCell
            
            if let stats = matchStatsArray?[indexPath.row] {
                
                cell.configureS(stats)
                cell.setNeedsDisplay()
            }
            return cell
        }
    }
}

