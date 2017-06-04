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


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesCancelled(touches, with: event)
    }
}
