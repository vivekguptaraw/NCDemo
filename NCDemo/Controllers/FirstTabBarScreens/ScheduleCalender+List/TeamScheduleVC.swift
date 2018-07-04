//
//  TeamScheduleVC.swift
//  NCDemo
//
//  Created by Vivek Gupta on 28/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import UIKit


class TeamScheduleVC: UIViewController {

    @IBOutlet weak var parentView: UIView!
    var ncScheduleListView: NCScheduleListView?
    var shouldUpdateFrames = true
    var tempData: [[String: [NCTeamScheduleModel]]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarItem = UITabBarItem(title: "Schedule", image: UIImage(named: "icon-authors"), tag: 0)
        self.navigationController?.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .bold)], for: UIControlState.normal)
        self.getTeamSchedule()
    }
    
    func getTeamSchedule(){
        NCSDKManager.shared.queryManager?.getTeamScheduleForCalendar(leagueId: "00", isAscending: true, options: .databaseElseNetwork, completionHandler: {[weak self] (monthsArray, teamScheduleArrayOfDict, indexPath, error) in
            if error == nil{
                guard let slf = self, let teamSchedules = teamScheduleArrayOfDict else{ return}
                if teamSchedules.count > 0{
                    slf.tempData = teamScheduleArrayOfDict
                    slf.viewDidLayoutSubviews()
                }
            }else{
                print("got error")
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.shouldUpdateFrames{
            if tempData != nil{
                self.createControl(teamScheduleArrayOfDict: tempData!)
                self.shouldUpdateFrames = false
            }
        }
        self.viewDidLayoutSubviews()
    }
    
    func createControl(teamScheduleArrayOfDict : [[String: [NCTeamScheduleModel]]]){
        let frm = parentView.bounds
        ncScheduleListView = NCScheduleListView(frame: frm)
        ncScheduleListView?.loadData(teamSchedule: teamScheduleArrayOfDict)
        parentView.addSubview(ncScheduleListView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("didLayoutSubview")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
