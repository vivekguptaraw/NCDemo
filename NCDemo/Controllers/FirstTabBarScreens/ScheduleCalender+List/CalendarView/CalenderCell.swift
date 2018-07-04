//
//  CalenderCell.swift
//  DynamicUIDemo
//
//  Created by Vivek Gupta on 24/05/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import UIKit

protocol CalenderCellDelegate{
    func getFirstSelectedCell(section : Int, rowInCollection : Int)
}

class CalenderCell: UICollectionViewCell {
    var dayLabel: UILabel!
    var teamLabel: UILabel!
    var delegate: CalenderCellDelegate?
    var date : Date!
    var gameDate : GameDate!
    var isOldGameDate: Bool = false
    var indexPath = IndexPath(row: 0, section: 0)
    var isCellSelected: Bool = false
    var gameIndexPathInParentCollection: IndexPath?
    override init(frame: CGRect) {
        super.init(frame: frame)
        dayLabel = UILabel()
        teamLabel = UILabel()
        var fontSize: CGFloat = 11
        if UIScreen.main.bounds.width <= 320 {
            fontSize = 10
        }
        self.dayLabel.font = UIFont.systemFont(ofSize: fontSize)
        self.teamLabel.font = UIFont.systemFont(ofSize: fontSize + 1)
        self.addSubview(dayLabel)
        self.addSubview(teamLabel)
        self.dayLabel.textAlignment = .center
        self.teamLabel.textAlignment = .center
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dayLabel.frame = CGRect(x: 0, y: 0, width: 20, height: 16)
        
        self.teamLabel.sizeToFit()
        var teamLabelHeight: CGFloat = self.teamLabel.frame.height
        var yPos: CGFloat = (self.frame.height - teamLabelHeight) / 2
        if self.indexPath.section != 0 {
            
        }else{
           
        }
        teamLabel.frame = CGRect(x: ((frame.size.width - (frame.size.width - 8)) / 2) + 2 , y: yPos , width: frame.size.width - 8, height: teamLabelHeight)
        if isCellSelected{
            self.showSelectionView()
        }else{
            removeSelectionView()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(indexPath: IndexPath, parentIndexPath: IndexPath, dateModel: DateModel, dayDictionary: inout [String: GameDate], isFirstTime : Bool, selectedIndex: IndexPath?){
        self.indexPath = indexPath
        if indexPath.section == 0 {
            self.dayLabel.isHidden = true
            self.teamLabel.text = dateModel.week(at: indexPath.row)
            
            self.teamLabel.textColor = UIColor.hexStringToUIColor(hex: "283954")
            self.backgroundColor = UIColor.hexStringToUIColor(hex: "82abed")
            
        }else{
            
            self.dayLabel.isHidden = false
            let day = dateModel.dayString(at: indexPath, isHiddenOtherMonth: true)
            self.date = dateModel.date(at: indexPath)
            
            if day == ""{
                self.teamLabel.text = ""
                self.dayLabel.text = ""
                self.backgroundColor = UIColor.hexStringToUIColor(hex: "d6dbd6").withAlphaComponent(0.5)
            }else{
                self.backgroundColor = UIColor.hexStringToUIColor(hex: "999da3")
                self.dayLabel.text = day
                let gameDate = dayDictionary[day]
                
                guard let gdt = gameDate else{
                    self.teamLabel.text = ""
                    self.backgroundColor = UIColor.lightGray
                    self.setBorderToSelectedView(shouldAddBorder: false)
                    return
                }
                
                dayDictionary[day]?.gameIndexInCalendarCV = indexPath.row
                if let game =  dayDictionary[day]{
                    self.gameIndexPathInParentCollection = IndexPath(item: game.gameIndexInParentCV , section: parentIndexPath.section)
                }
                
                if isFirstTime{
                    
                }
                
//                if gdt.gameModel.isHomeGame{
//                    self.teamLabel.text = gdt.gameModel.visitorTeamAbbre
//                    let order = Calendar.current.compare(self.date, to: Date(), toGranularity: .day)
//                    if order == .orderedAscending{
//                        self.isOldGameDate = true
//                    }else{
//                        self.isOldGameDate = false
//                    }
//                    self.teamLabel.textColor = UIColor.hexStringToUIColor(hex: "073a08")
//                }else{
//                    self.teamLabel.textColor = UIColor.hexStringToUIColor(hex: "bf181b")
//                    self.backgroundColor = UIColor.lightGray
//                    self.teamLabel.text = gdt.gameModel.homeTeamAbbre
//                }
                if let selectdIndex = selectedIndex{
                    if selectdIndex.item == indexPath.item{
                        
                    }else{
                        
                    }
                }
            }
        }
    }
    
    func setBorderToSelectedView(shouldAddBorder: Bool) {
        if shouldAddBorder {
            isCellSelected = true
        }
        else {
            isCellSelected = false
        }
       
    }
    
    func showSelectionView() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.red.cgColor
        //self.layoutSubviews()
    }
    
    func removeSelectionView() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gameIndexPathInParentCollection = nil
        self.isCellSelected = false
    }
    
    
    
}
