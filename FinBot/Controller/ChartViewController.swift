//
//  ChartViewController.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 10/5/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UITableViewController {
    
    var user: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoLightBtn = UIButton(type: .infoLight)
        infoLightBtn.tintColor = UIColor.black
        infoLightBtn.addTarget(self, action: #selector(tutorial), for: .touchUpInside)
        let barBtn = UIBarButtonItem(customView: infoLightBtn)
        navigationItem.rightBarButtonItem = barBtn
        //self.view.alpha = 0.0
        navigationItem.title = "DASHBOARD"
        self.tableView.register(LineChartCell.self, forCellReuseIdentifier: "CELL")
    }
    
    @objc func tutorial() {
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tutVC = story.instantiateViewController(withIdentifier: "tutorial") as! TutorialViewController
        present(tutVC, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LineChartCell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! LineChartCell
        if indexPath.section == 0 {
            cell.updateGraph(user: user)
        }
        else if indexPath.section == 1 {
            cell.updatePieChart(user: user)
        }
        else if indexPath.section == 2 {
            cell.updateBarChart(user: user)
        }
        else if indexPath.section == 3 {
            cell.updateHorizBarChart(user: user)
        }
        else if indexPath.section == 4 {
            cell.updateTwoLineChart(user: user)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "LINE CHART VIEW"
        }
        else if section == 1 {
            return "PIE CHART VIEW"
        }
        else if section == 2 {
            return "BAR CHART VIEW"
        }
        else if section == 3 {
            return "HORIZONTAL BAR CHART VIEW"
        }
        else if section == 4 {
            return "DUO LINE CHART VIEW"
        }
        return ""
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "modal" {
//            let destVC = segue.destination as! TutorialViewController
//            destVC.view.layer.shadowOpacity = 0.7
//            destVC.view.layer.masksToBounds = true
//            destVC.view.layer.cornerRadius = 10
//        }
//    }
}

