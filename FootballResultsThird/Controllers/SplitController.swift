//
//  SplitController.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 03/07/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class SplitController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        
        if let svc = secondaryViewController as? MatchDetailsViewController {
            return true
        } else {
            return false
        }
    }
    
}
