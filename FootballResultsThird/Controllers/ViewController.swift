//
//  ViewController.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 05/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

let day: Double = 60 * 60 * 24

enum FixturesTimeFrame {
    
    case yesterday
    case today
    case tomorrow
    
    var date: String {
        
        switch self {
        case .yesterday:
            return Date.gameFixture(timeInterval: -day)
        case .today:
            return Date.gameFixture(timeInterval: nil)
        case .tomorrow:
            return Date.gameFixture(timeInterval: day)
        }
        
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants & Variables, mainly for caching fetched data
    
    fileprivate let scoreViewModelController = ScoreViewModelController()
    @IBOutlet weak var dateSC: UISegmentedControl!

    @IBOutlet weak var tableScore: UITableView!
    private let refreshControl = UIRefreshControl()
    // Cells ID
    let score = "scoreCell"
    let noScore = "noCompetition"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        settingTitlesInSC()
        
        tableScore.prefetchDataSource = self
        
        scoreViewModelController.retrieveScores(from: FixturesTimeFrame.today.date) { [weak self] (success, error) in
            
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
        
        tableScore.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(ViewController.refreshData(sender:)), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Refreshing data by pulling table

    func refreshData(sender: UIRefreshControl) {
        
        var dateForTab: String?
        
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
        
        scoreViewModelController.retrieveScores(from: dateForTab!) { [weak self] (success, error) in
            
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
        
        scoreViewModelController.retrieveScores(from: dateForTab!) { [weak self] (success, error) in
            
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
    
    func showTable(sender: TableButton) {
        print("🔴🔴🔴 table for \(scoreViewModelController.competitionsToday[sender.section!]) will be added later")
    }
    
    // MARK: Table methods
    
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scoreViewModelController.competitionsToday.count != 0 {
            return scoreViewModelController.competitionsSorted[scoreViewModelController.competitionsToday[section]]!.count
        } else {
            return 1
        }
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
            
        }
        //print("index path: \(indexPath.row) - \(indexPath) = \(imageLoadOperations.count)")
        return cell
            
        } else {
            
            let cell = tableScore.dequeueReusableCell(withIdentifier: noScore, for: indexPath)
            return cell

        }
        
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        let dictionary = scoreViewModelController.teamsDictGlobal
//        
//        guard let scoreModel = scoreViewModelController.fixture(at: indexPath.section, at: indexPath.row),//scoreViewModelController.competitionsSorted[scoreViewModelController.competitionsToday[indexPath.section]]?[indexPath.row],
//            let imageLoadOperationHome = imageLoadOperations[(dictionary[scoreModel.homeTeam]?.logoURL)!],
//            let imageLoadOperationAway = imageLoadOperations[(dictionary[scoreModel.awayTeam]?.logoURL)!]
//            else { return
//                print("doesn't work") }
//        
//        imageLoadOperationHome.cancel()
//        imageLoadOperationAway.cancel()
//        print("operation status isCancelled: \(imageLoadOperationHome.isCancelled) || operation status: \(imageLoadOperationAway.isCancelled)")
//        //        print("operation status isFinished: \(imageLoadOperationHome.isFinished) || operation status: \(imageLoadOperationAway.isFinished)")
//        //        print("operation status isExecuting: \(imageLoadOperationHome.isExecuting) || operation status: \(imageLoadOperationAway.isExecuting)")
//        print("links for logo: \(dictionary[scoreModel.homeTeam]?.logoURL) || \(dictionary[scoreModel.awayTeam]?.logoURL)")
//        
//        //        imageLoadOperations.removeValue(forKey: (dictionary[scoreModel.homeTeam]?.logoURL)!)
//        //        imageLoadOperations.removeValue(forKey: (dictionary[scoreModel.awayTeam]?.logoURL)!)
//    }
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


