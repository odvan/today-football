//
//  SettingsViewController.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 20/06/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants & Variables

    var selectedCompetitionsDictionary: [String : Bool] = [Competition.PD.name : true,
                                                           Competition.PL.name : true,
                                                           Competition.SA.name : true,
                                                           Competition.FL1.name : true,
                                                           Competition.BL1.name : true,
                                                           Competition.CL.name : true]
    var selectedCompetitions = [String]()
    
    @IBOutlet weak var tableSettings: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let dictionary = UserDefaults.standard.object(forKey: kSelectedForSVC) as? [String : Bool] {
            print("dictionary != nil")
        selectedCompetitionsDictionary = dictionary
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected comp")
        let selectedCell = tableSettings.cellForRow(at: indexPath)! as UITableViewCell

        if selectedCell.accessoryType == .checkmark {
            let allCompSelected = selectedCompetitionsDictionary.filter{ $0.1 == true }.count
            if allCompSelected < 2 {
                return
            }
            selectedCell.accessoryType = .none
            selectedCompetitionsDictionary[Array(selectedCompetitionsDictionary.keys)[indexPath.row]] = false
        } else {
            
            selectedCell.accessoryType = .checkmark
            selectedCompetitionsDictionary[Array(selectedCompetitionsDictionary.keys)[indexPath.row]] = true
        }
    
        //tableSettings.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Select competitions to follow."
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCompetitionsDictionary.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableSettings.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = Array(selectedCompetitionsDictionary.keys)[indexPath.row]
        
        if (selectedCompetitionsDictionary[Array(selectedCompetitionsDictionary.keys)[indexPath.row]])! {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "backWithSelectedComp" {
            
            UserDefaults.standard.set(selectedCompetitionsDictionary, forKey: kSelectedForSVC)
            selectedCompetitions = selectedCompetitionsDictionary.filter{ $0.1 == true }.map{ $0.0 }
            let selectedCompetitionsForURLPath = Competition.creatingStringForUrlPath(from: selectedCompetitions)
            UserDefaults.standard.set(selectedCompetitionsForURLPath, forKey: kForDefaultSelectedCompetitons)
            
            print("🆔 \(selectedCompetitionsForURLPath)")
        }
    }

}
