//
//  TableButton.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 30/04/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class TableButton: UIButton {
    
    
    var section: Int?
    
    override var isHighlighted: Bool {
        didSet {
            //backgroundColor = isHighlighted ? .gray : .blue
            self.setTitleColor(UIColor.darkGray, for: .highlighted)
            self.setTitleColor(UIColor.darkGray, for: [.highlighted, .selected])
            
        }
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
