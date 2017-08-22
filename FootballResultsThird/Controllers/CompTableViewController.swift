//
//  CompTableViewController.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 21/05/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class CompTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableStandings: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!

    let cellID = "standingsCell"
    let cellHeaderID = "standingsHeaderCell"
    
    var teamsDictionary: [String : Team] = [:]
    var league: String?
    static var standingsCache: [String : [TeamsStandings]] = [:]

//    var teamsStandings: [TeamsStandings]? {
//        didSet {
//            print("league link: \(league)")
//            print("standings: \(teamsStandings)")
//            
//           // if standingsCache[league!] == nil {
//                standingsCache[league!] = teamsStandings
//            //}
//            
////            DispatchQueue.main.async {
////                self.tableStandings.reloadData()
////            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableStandings.delegate = self
        tableStandings.dataSource = self
        
        tableStandings.backgroundView = activityindicator
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("league is: \(league!)")
        if CompTableViewController.standingsCache[league!] == nil {
            
            activityindicator.startAnimating()

            TeamsStandings.fetchingStandings(for: league!) { [weak self] (teamsStandings) in
                
                guard let strongSelf = self else { return }

                //tVC.teamsStandings
                CompTableViewController.standingsCache[strongSelf.league!] = teamsStandings

                DispatchQueue.main.async {
                    strongSelf.activityindicator.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    strongSelf.tableStandings.reloadData()
                }
                
            }
        }
//        print("league link: \(league)")
//        print("standings: \(teamsStandings)")
//
//        DispatchQueue.main.async {
//                self.tableStandings.reloadData()
//            }

    }
    
    @IBAction func done(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        //        tableStandings.dataSource = nil
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if CompTableViewController.standingsCache[league!] != nil {
            return CompTableViewController.standingsCache[league!]!.count + 1
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dictionary = teamsDictionary
        
        if indexPath.row == 0 {
            let cellHeader = tableStandings.dequeueReusableCell(withIdentifier: cellHeaderID, for: indexPath)
            return cellHeader
            
        }
        
        let cell = tableStandings.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! StandingsCell
        
        if let standingsModel = CompTableViewController.standingsCache[league!]?[indexPath.row - 1] {
            
            cell.fillingTable(standingsModel)
            cell.teamName.text = dictionary[standingsModel.teamName]?.shortName
            
        }
        
        return cell
    }
}
