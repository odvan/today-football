//
//  ScoreCellTableViewCell.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 13/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

// MARK: Customizing cell for table


class ScoreCell: UITableViewCell {
    
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    
    @IBOutlet weak var homeTeamLogo: CustomImageView!
    @IBOutlet weak var awayTeamLogo: CustomImageView!
    
    @IBOutlet weak var score: PaddedLabel!
    @IBOutlet weak var gameStatus: UILabel!
    
    @IBOutlet weak var odds: UILabel!
    
    @IBOutlet weak var liveGameSign: UIView!
    
    var operG: ImageLoadOperation?
    var operTwoG: ImageLoadOperation?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setOpaqueBackground()
        liveGameSign.layer.cornerRadius = 4

    }
    
    
    func configure(_ scoreModel: ScoreViewModel) {
        
        // Teams logo pictures will be assigned asynchronously through an ImageLoadOperation
        
        // Teams short name will be assigned in main VC

        score.text = scoreModel.gameResult
        gameStatus.text = Date.gameStatus(date: scoreModel.date, status: scoreModel.gameStatus)
        odds.text = scoreModel.odds
       
        if scoreModel.gameStatus == .inPlay {
            liveGameSign.alpha = 1.0
        }

        //isUserInteractionEnabled = false  // Cell selection is not required for this sample, maybe later
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        homeTeamLogo.image = nil
        awayTeamLogo.image = nil
        liveGameSign.alpha = 0
        
        if let operation = operG {
            if !operation.isFinished {
                operation.cancel()
                print("Operation \(operation.url) during Cell reuse cancelled")
                operG = nil
            }
        }
        
        if let operationTwo = operTwoG {
            if !operationTwo.isFinished {
                operationTwo.cancel()
                print("Operation \(operationTwo.url) during Cell reuse cancelled")
                operTwoG = nil
            }
        }
        
        print("reuse cell")

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

private extension ScoreCell {
    static let defaultBackgroundColor = UIColor.white
    
    func setOpaqueBackground() {
        alpha = 1.0
        backgroundColor = ScoreCell.defaultBackgroundColor
        homeTeamLogo.alpha = 1.0
        awayTeamLogo.alpha = 1.0
        homeTeamLogo.backgroundColor = ScoreCell.defaultBackgroundColor
        awayTeamLogo.backgroundColor = ScoreCell.defaultBackgroundColor

    }
}

