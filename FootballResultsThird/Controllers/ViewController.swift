//
//  ViewController.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 05/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate {
    
    // MARK: Constants & Variables
    
    fileprivate let scoreViewModelController = ScoreViewModelController()

    @IBOutlet weak var dateSC: UISegmentedControl!
    
    let dSelectedCompetitions = "PD,SA,PL,FL1,BL1,CL"
    var selectedCompetitions: String!
    
    @IBOutlet weak var tableScore: UITableView!
    private let refreshControl = UIRefreshControl()
    
    // Cells ID
    let score = "scoreCell"
    let noScore = "noCompetition"
    var rowSelectedAtLeastOnce = false
    var collapseDetailViewController = true
    
    
    // MARK: ViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        splitViewController?.delegate = self
        splitViewController?.maximumPrimaryColumnWidth = self.view.frame.size.width
        splitViewController?.preferredPrimaryColumnWidthFraction = 0.5
        
        print("initial values: \(UserDefaults.standard.object(forKey: GlobalKey.selectedCompetitonsForUrlPath))")
        if UserDefaults.standard.object(forKey: GlobalKey.selectedCompetitonsForUrlPath) == nil {
            UserDefaults.standard.register(defaults: [GlobalKey.selectedCompetitonsForUrlPath : dSelectedCompetitions])
        }
        
        settingTitlesInSC()
        
        tableScore.prefetchDataSource = self
        
        tableScore.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(ViewController.refreshData(sender:)), for: .valueChanged)
        
        print("\(self.view.frame.size.width), collapsed: \(splitViewController?.isCollapsed)")
        if self.view.frame.size.width == 736 {
            firstSegue()
        }
//        self.tableScore.contentInset = UIEdgeInsetsMake(64,0,0,0)
        //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.firstSegue), name: .UIViewControllerShowDetailTargetDidChange, object: nil)
        //self.tableScore.delaysContentTouches = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedCompetitions = UserDefaults.standard.object(forKey: GlobalKey.selectedCompetitonsForUrlPath) as! String!

        dateFetchSC(sender: self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("view bounds:\(view.bounds.height)|\(view.bounds.width)")
        if view.bounds.height == 370 && rowSelectedAtLeastOnce == false {
            firstSegue()
        }
    }
    
    
    // MARK: Refreshing data by pulling table

    func refreshData(sender: UIRefreshControl) {
        
        dateFetchSC(sender: sender)
        refreshControl.endRefreshing()
    }
    
    // MARK: Segmented Control - setting date titles for tabs
    
    private func settingTitlesInSC() {
        
        dateSC.setTitle(Date.forTabs(timeInterval: -day), forSegmentAt: 0)
        dateSC.setTitle(Date.forTabs(timeInterval: nil), forSegmentAt: 1)
        dateSC.setTitle(Date.forTabs(timeInterval: day), forSegmentAt: 2)
    }
    
    // MARK: Segmented Control - selecting tab
    
    @IBAction func dateFetchSC(_ sender: Any) {
        
        var dateForTab: String?
        imageLoadQueue.cancelAllOperations()
        
        switch dateSC.selectedSegmentIndex {
        case 0:
            dateForTab = FixturesTimeFrame.yesterday.date
        case 1:
            dateForTab = FixturesTimeFrame.today.date
        case 2:
            dateForTab = FixturesTimeFrame.tomorrow.date
        default:
            break
        }
        
        scoreViewModelController.retrieveScores(from: dateForTab!, and: selectedCompetitions) { [weak self] (success, error) in
            
            guard let strongSelf = self else { return }
            
            if !success {
                DispatchQueue.main.async {
                    let title = "Error"
                    if let error = error {
                        strongSelf.showError(title, message: error.localizedDescription)
                    } else {
                        strongSelf.showError(title, message: NSLocalizedString("Can't retrieve results.", comment: "The message displayed when results can’t be retrieved."))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.tableScore.reloadData()
                }
            }
        }

    }
    
    
    // MARK: Methods for navigation to Standings table
    
    func showTable(sender: TableButton) {
        
        performSegue(withIdentifier: "connectionToCompTable", sender: sender)
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CompetitionTable") as! CompTableViewController
//        nextViewController.league = scoreViewModelController.competitionsLinks[sender.section!]
//        let _ = nextViewController.view
//        nextViewController.navBar.topItem?.title = scoreViewModelController.competitionsToday[sender.section!]
//        nextViewController.teamsDictionary = scoreViewModelController.teamsDictGlobal

//        self.present(nextViewController, animated: true, completion: nil)
        
        //print("🔴🔴🔴 table for \(scoreViewModelController.competitionsToday[sender.section!]) will be added later")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "connectionToCompTable" {
            
            if let standingsVC = segue.destination as? CompTableViewController {
                let _ = standingsVC.view
                standingsVC.navBar.topItem?.title = scoreViewModelController.competitionsToday[(sender as! TableButton).section!]
                standingsVC.league = scoreViewModelController.competitionsLinks[(sender as! TableButton).section!]
                standingsVC.teamsDictionary = scoreViewModelController.teamsDictGlobal
            }
        }
        
        if segue.identifier == "matchDetails" {
            
            if  let matchDetailsNC = segue.destination as? UINavigationController,
                let matchDetailsVC = matchDetailsNC.topViewController as? MatchDetailsViewController {
                
                rowSelectedAtLeastOnce = true
                let dictionary = scoreViewModelController.teamsDictGlobal
                
                matchDetailsVC.title = "Match Details"
                if let indexFirst = sender as? IndexPath {
                    if let cell = tableScore.cellForRow(at: indexFirst) as? ScoreCell {
                        if let scoreModel = scoreViewModelController.fixture(at: indexFirst.section, at: indexFirst.row) {
                            matchDetailsVC.score = scoreModel
                            matchDetailsVC.homeTeamName = cell.homeTeam.text
                            matchDetailsVC.awayTeamName = cell.awayTeam.text
                            matchDetailsVC.homeLogo = dictionary[scoreModel.homeTeam]?.logoURL
                            matchDetailsVC.awayLogo = dictionary[scoreModel.awayTeam]?.logoURL
                        }
                    }
                } else if let index = tableScore.indexPathForSelectedRow {
                    print("✝️ index \(index)")
                    if let scoreModel = scoreViewModelController.fixture(at: index.section, at: index.row) {
                        matchDetailsVC.score = scoreModel
                        let cell = tableScore.cellForRow(at: index) as! ScoreCell
                        matchDetailsVC.homeTeamName = cell.homeTeam.text
                        matchDetailsVC.awayTeamName = cell.awayTeam.text
                        matchDetailsVC.homeLogo = dictionary[scoreModel.homeTeam]?.logoURL
                        matchDetailsVC.awayLogo = dictionary[scoreModel.awayTeam]?.logoURL
                    }
                }
            }
        }
        
    }
    
    @IBAction func unwindWithSelectedCompetitions(segue:UIStoryboardSegue) {
                
        print("unwing segue")
    }
    
    // MARK: UISplitViewControllerDelegate
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

        print(" 💔 💔 💔 💔")
        return collapseDetailViewController
    }
    
    // Show first cell in DetailView
    func firstSegue() {
        rowSelectedAtLeastOnce = true
        print("It's iPhone Plus in landscape mode, collapsed: \(splitViewController?.isCollapsed), view bounds:\(view.bounds.height)|\(view.bounds.width)")
        let initialIndexPath = IndexPath(row: 0, section: 0)
        self.tableScore.selectRow(at: initialIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        
        let delayInSeconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            self.performSegue(withIdentifier: "matchDetails", sender: initialIndexPath)
        }
        collapseDetailViewController = false
    }
    
    // MARK: Small method for creating Table's footer programmatically
    
    private func footer(for table: UITableView) -> UIView {
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        footer.backgroundColor = UIColor.groupTableViewBackground
        let footerlabel = UILabel(frame: CGRect(x: 12, y: 16, width: footer.frame.width - 24, height: 12))
        footerlabel.text = "* Team won by penalty."
        footerlabel.font = UIFont(name: "AvenirNext-Medium", size: 10)
        footer.addSubview(footerlabel)
        
        return footer
    }

    
    // MARK: Table's methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return (scoreViewModelController.competitionsToday.count != 0) ? scoreViewModelController.competitionsSorted.keys.count : 1
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if scoreViewModelController.competitionsToday.count != 0 {
            return scoreViewModelController.competitionsToday[section]
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)
        
        if (view.subviews.last?.isKind(of: UIButton.self))! {
            view.subviews.last?.removeFromSuperview()
        }
        
        if scoreViewModelController.competitionsToday[section] == Competition.CL.name {
            return
        } else {
            
            let standingsButton = TableButton(type: UIButtonType.system)
            standingsButton.setTitle("Table", for: .normal)
            standingsButton.section = section
            standingsButton.addTarget(self, action: #selector(ViewController.showTable(sender:)), for: UIControlEvents.touchUpInside)
            view.addSubview(standingsButton)
            
            // Place button on far right margin of header
            standingsButton.translatesAutoresizingMaskIntoConstraints = false
            standingsButton.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
            standingsButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scoreViewModelController.competitionsToday.count != 0 {
            return scoreViewModelController.competitionsSorted[scoreViewModelController.competitionsToday[section]]!.count
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        performSegue(withIdentifier: "matchDetails", sender: indexPath)
        //        tableScore.deselectRow(at: indexPath, animated: true)
        //        collapseDetailViewController = false

    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if scoreViewModelController.competitionsToday.count != 0 {
            let cell = tableScore.dequeueReusableCell(withIdentifier: score, for: indexPath) as! ScoreCell
            let dictionary = scoreViewModelController.teamsDictGlobal
            
            if let scoreModel = scoreViewModelController.fixture(at: indexPath.section, at: indexPath.row) {
                
                cell.configure(scoreModel)
                
                cell.homeTeam.text = dictionary[scoreModel.homeTeam]?.shortName
                cell.awayTeam.text = dictionary[scoreModel.awayTeam]?.shortName
                
                cell.homeTeamLogo.updateLogo(link: dictionary[scoreModel.homeTeam]?.logoURL)
                cell.operG = ImageLoadOperation(url: (dictionary[scoreModel.homeTeam]?.logoURL)!)
                cell.awayTeamLogo.updateLogo(link: dictionary[scoreModel.awayTeam]?.logoURL)
                cell.operTwoG = ImageLoadOperation(url: (dictionary[scoreModel.awayTeam]?.logoURL)!)
                
                if scoreModel.penalty?.hashValue == 0 {
                    
                    cell.homeTeam.text! += "*"
                    tableScore.tableFooterView = footer(for: tableScore)
                }
                if scoreModel.penalty?.hashValue == 1 {
                    
                    cell.awayTeam.text! += "*"
                    tableScore.tableFooterView = footer(for: tableScore)
                }
                
            }
            
            //print("index path: \(indexPath.row) - \(indexPath) = \(imageLoadOperations.count)")
            return cell
            
        } else {
            
            let cell = tableScore.dequeueReusableCell(withIdentifier: noScore, for: indexPath)
            return cell
            
        }
        
    }
    

    
}

// MARK: Prefetching data

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        let dictionary = scoreViewModelController.teamsDictGlobal

        for indexPath in indexPaths {
            
            guard let scoreModel = scoreViewModelController.fixture(at: indexPath.section, at: indexPath.row),
                let linkHome = dictionary[scoreModel.homeTeam]?.logoURL,
                let linkAway = dictionary[scoreModel.awayTeam]?.logoURL
                else { return }
           
            if let _ = imgCache.object(forKey: linkHome as AnyObject),
                let _ = imgCache.object(forKey: linkAway as AnyObject) {
                return
            }
            
            let imageLoadOperationHome = ImageLoadOperation(url: linkHome)
            let imageLoadOperationAway = ImageLoadOperation(url: linkAway)
            
            imageLoadQueue.addOperations([imageLoadOperationHome, imageLoadOperationAway], waitUntilFinished: false)
            imgCache.setObject(imageLoadOperationHome, forKey: linkHome as AnyObject)
            imgCache.setObject(imageLoadOperationAway, forKey: linkAway as AnyObject)
        }
        
//            #if DEBUG_CELL_LIFECYCLE
//                print(String.init(format: "prefetchRowsAt #%i", indexPath.row))
//            #endif
        }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        let dictionary = scoreViewModelController.teamsDictGlobal

        for indexPath in indexPaths {
            
            guard let scoreModel = scoreViewModelController.fixture(at: indexPath.section, at: indexPath.row) else { return }
            let imageLoadOperationHome = ImageLoadOperation(url: (dictionary[scoreModel.homeTeam]?.logoURL)!)
            let imageLoadOperationAway = ImageLoadOperation(url: (dictionary[scoreModel.awayTeam]?.logoURL)!)

            imageLoadOperationHome.cancel()
            imageLoadOperationAway.cancel()
            
//            #if DEBUG_CELL_LIFECYCLE
//                print(String.init(format: "cancelPrefetchingForRowsAt #%i", indexPath.row))
//            #endif
        }
    }
}

// MARK: Extension to show UIAlert when data can't be fetched

extension UIViewController {
    func showError(_ title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}


