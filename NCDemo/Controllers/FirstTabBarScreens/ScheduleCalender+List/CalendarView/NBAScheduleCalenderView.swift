//
//  NBAScheduleCalenderView.swift
//  DynamicUIDemo
//
//  Created by Vivek Gupta on 24/05/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import UIKit

class GameScheduleModel{
    var date: String!
    var isHomeGame:Bool = false
    var league_id:String = ""
    var visitorTeamAbbre: String = ""
    var homeTeamAbbre: String = ""
    
    init() {
    }
}

struct GameDate {
    var gameModel : NCTeamScheduleModel!
    var gameIndexInParentCV : Int!  //index position in dayWiseGameModelDictionary
    var gameIndexInCalendarCV : Int!
}

protocol CalendarViewDelegate: class {
    func selectedDate(parentIndexPath : IndexPath, rowInCollection : Int)
}

class NBAScheduleCalenderView: UIView {
    
    var collectionView: UICollectionView!
    var dayWiseGameModelDictionary: [String: GameDate] = [:]
    var model: DateModel = .init()
    var scheduleListPerMonth : [NCTeamScheduleModel] = []
    weak var delegate: CalendarViewDelegate?
    var parentIndexPath : IndexPath!
    var monthYear : String!
    var isFirstTime : Bool = false
    let cellIdenfier = "CalendarCell"
    
    public init(frame : CGRect,monthYear : String, scheduleArray : [NCTeamScheduleModel], selectedGameIndexPath : IndexPath?, isFirstTime : Bool, indexPath : IndexPath){
        
        super.init(frame: frame)
        let viewLayout = CalendarViewLayout(inset: .zero, cellSpace: 0.2, sectionSpace: 0.0, parentHeight: self.frame.height, maxRowCount: 6)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: viewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.parentIndexPath = indexPath
        self.monthYear = monthYear
        self.scheduleListPerMonth = scheduleArray
        generateDictionaryAsPerDay()
        self.configureCollectionView()
        self.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
    func generateDictionaryAsPerDay(){
        print("parentIndexPath.section \(parentIndexPath.section)")
        for (index, model) in self.scheduleListPerMonth.enumerated(){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dt = formatter.string(from: model.gameIsoDate!.getDatePerCurrentTimeZone()!)
            let yearMonthDayArray = dt.components(separatedBy: "-")
            let day = yearMonthDayArray.last!
            var gameDate = GameDate()
            gameDate.gameModel = model
            gameDate.gameIndexInParentCV = index
            self.dayWiseGameModelDictionary[day] =  gameDate
            print("parentIndexPath.row \(day)")
            
        }
    }
    
    func configureCollectionView() {
        model.displayByMonth(in: monthYear)
        self.backgroundColor = UIColor.gray
        setLayoutCollectionView()
        self.collectionView.register(CalenderCell.self, forCellWithReuseIdentifier: cellIdenfier)
        self.collectionView.reloadData()
    }
    
    func setLayoutCollectionView() {
        
        let monthYearArray = monthYear.components(separatedBy: "-")
        
        let month    = Int(monthYearArray[1])
        let year     = Int(monthYearArray[0])
        let noOfWeeks = model.weeksInMonth(month: month!, year: year!)
        let viewLayout = CalendarViewLayout(inset: .zero, cellSpace: 0.1, sectionSpace: 0.1, parentHeight: self.collectionView.frame.height, maxRowCount: noOfWeeks)
        self.collectionView.setCollectionViewLayout(viewLayout, animated: false)
        
        print(self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var selectedIndexPath: IndexPath?
}

extension NBAScheduleCalenderView: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? DateModel.dayCountPerRow : (DateModel.dayCountPerRow * 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdenfier , for: indexPath) as! CalenderCell
        cell.updateCell(indexPath: indexPath,parentIndexPath : self.parentIndexPath, dateModel: model, dayDictionary: &dayWiseGameModelDictionary, isFirstTime: self.isFirstTime, selectedIndex: self.selectedIndexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndex = self.selectedIndexPath {
            let prevCell = collectionView.cellForItem(at: selectedIndex) as! CalenderCell
            prevCell.isCellSelected = false
            prevCell.layoutSubviews()
            collectionView.reloadItems(at: [selectedIndex])
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CalenderCell
        guard let gameIndexPath = cell.gameIndexPathInParentCollection else {return}
        selectedIndexPath = indexPath
        cell.isCellSelected = true
        cell.layoutSubviews()
        delegate?.selectedDate(parentIndexPath: gameIndexPath, rowInCollection: indexPath.row)
        
    }
    
    
}



