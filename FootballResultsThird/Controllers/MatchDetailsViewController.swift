//
//  MatchDetailsViewController.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 16/06/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class MatchDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var scoreLabel: PaddedLabel!
    @IBOutlet weak var homeTeamLogo: CustomImageView!
    @IBOutlet weak var awayTeamLogo: CustomImageView!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var statTable: UITableView!
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var liveGameSign: PaddedLabel!
    @IBOutlet weak var scoreHTLabel: UILabel!
    
    var score: ScoreViewModel?
    var homeLogo: String?
    var awayLogo: String?
    var homeTeamName: String?
    var awayTeamName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureMatchDetails(score!)
        self.homeTeam.text = homeTeamName
        self.awayTeam.text = awayTeamName
        self.homeTeamLogo.updateLogo(link: homeLogo)
        self.awayTeamLogo.updateLogo(link: awayLogo)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureMatchDetails(_ scoreModel: ScoreViewModel) {
        
        scoreLabel.text = scoreModel.gameResult
        if (scoreModel.gameHTResult != nil) {
        scoreHTLabel.text = scoreModel.gameHTResult
        } else {
            scoreHTLabel.isHidden = true
        }
        gameStatus.text = Date.gameStatus(date: scoreModel.date, status: scoreModel.gameStatus)
        //odds.text = scoreModel.odds
        
        if scoreModel.gameStatus == .inPlay {
            liveGameSign.alpha = 1.0
        }
        
        //isUserInteractionEnabled = false  // Cell selection is not required for this sample, maybe later
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
