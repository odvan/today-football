//
//  StatViewLine.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 01/07/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class StatViewLine: UIView {
    
    var number: CGFloat?
    var numberOverall: CGFloat?
    var leftSide: Bool = false

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let width = rect.width
        let height = rect.height
        
//        let backlinePath = UIBezierPath()
//        backlinePath.lineWidth = 8.0
//        
//        let backStartPoint = CGPoint(x: 0, y: height/2)
//        let backEndPoint = CGPoint(x: width, y: height/2)
//        
//        backlinePath.move(to: backStartPoint)
//        backlinePath.addLine(to: backEndPoint)
//        
//        let backColor = UIColor(red: 102/255, green: 255/255, blue: 204/255, alpha: 0.3)
//        backColor.setStroke()
//       // backlinePath.stroke()
        
        let linePath = UIBezierPath()
        linePath.lineWidth = 10.0
        
        let color = UIColor(red: 102/255, green: 255/255, blue: 204/255, alpha: 1.0)
        color.setStroke()
        
        if number! > 0, leftSide == true {
            
            let firstPoint = CGPoint(x: width, y: height/2)
            let secondPoint = CGPoint(x: (1 - (number!/numberOverall!)) * width,
                                      y: height/2)
            linePath.move(to: firstPoint)
            linePath.addLine(to: secondPoint)
            
            linePath.stroke()
            print("trying to draw left side, fp: \(firstPoint), sp: \(secondPoint), \(number), \(numberOverall)")
            
        } else if number! > 0, leftSide == false {
            
            let firstPoint = CGPoint(x: 0, y: height/2)
            let secondPoint = CGPoint(x: (number!/numberOverall!) * width,
                                      y: height/2)
            linePath.move(to: firstPoint)
            linePath.addLine(to: secondPoint)
            
            linePath.stroke()
            print("trying to draw right side, fp: \(firstPoint), sp: \(secondPoint), \(number), \(numberOverall)")
            
        }
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 102/255, green: 255/255, blue: 204/255, alpha: 1.0).cgColor

    }

}
