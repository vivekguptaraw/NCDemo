//
//  ViewController.swift
//  NCDemo
//
//  Created by Vivek Gupta on 27/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var queryManager: NCQueryManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sportsManager = NCSportsManger.init(activateService: [.ALL])
        self.queryManager = sportsManager.queryManager
        getGameSchedule()
    }
    
    func getGameSchedule(){
        self.queryManager?.getTeamScheduleBy(leagueId: "00", sortBy: NCTeamSchedule.gameIsoDate, isAscending: false, options: .databaseElseNetwork, completionHandler: { (teamScheduleArray, error) in
            print(teamScheduleArray)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

