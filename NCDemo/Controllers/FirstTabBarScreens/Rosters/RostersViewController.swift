//
//  RostersViewController.swift
//  NCDemo
//
//  Created by Vivek Gupta on 28/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import UIKit

class RostersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarItem = UITabBarItem(title: "Rosters", image: UIImage(named: "icon-authors"), tag: 0)
        self.navigationController?.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .bold)], for: UIControlState.normal)
       
        // Do any additional setup after loading the view.
    }
    
    func getRostersData(){
        NCSDKManager.shared.queryManager?.getPlayersBy(teamId: "1610612737", leagueId: "00", sortBy: NCPlayer.firstName, isAscending: true, options: NCFetchOptions.databaseElseNetwork, completionHandler: { (playerModelArray, error) in
            print(playerModelArray)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
