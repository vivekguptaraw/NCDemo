 //
//  NCScheduleListView.swift
//  DynamicUIDemo
//
//  Created by Vivek Gupta on 07/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//
//
import UIKit
var headerAndMonthsBGcolor: UIColor = UIColor.lightGray.withAlphaComponent(0.8)
class NCScheduleListView: UIView {
    var gameCollectionView: UICollectionView!
    var gameTableViewWithCalendar: UITableView!
    var topFixedHeaderView: UIView = UIView()
    var teamScheduleArrayOfDictionary: [[String: [NCTeamScheduleModel]]] = []
    var gameModelsArray: [NCTeamSchedule] = []
    var sortedScheduleDate: [String]  = [String]()
    private var dateFormatter   = DateFormatter()
    private var calendar        = Calendar.autoupdatingCurrent
    let cellIdentifier = "NCScheduleListCell"
    let monthCellIdentifier = "NCMonthCollectionCell"
    var normalCellHeight: CGFloat = UIScreen.main.bounds.width * 0.55
    var centerMonthButton: UIButton = UIButton()
    var expandableMonthView: UIView = UIView()
    var monthCollectionView: UICollectionView!
    let monthCollectionCellWidth: CGFloat = (UIScreen.main.bounds.width / 3) - 20
    var shoulShowMonthsView: Bool = false
    var selectedMonthIndex: Int = 0
    var isFirstTimeMonthsShowing: Bool = true
    var monthCollHeight: CGFloat = 140
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var monthsArray: [String] = []
    var leftButton: UIButton = UIButton()
    var rightButton: UIButton = UIButton()
    var showCalenderTableView: Bool = true
    var centerMonthClicked: Bool = false
    var shouldShowCalendar: Bool = true
    var shadowView: UIView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func reloadWholeView(){
        
    }
    
    
    func loadData(teamSchedule: [[String: [NCTeamScheduleModel]]]){
        self.teamScheduleArrayOfDictionary = teamSchedule
        self.createViewAndAddSubview()
        self.setMonthArray()
        self.fillMonthsAsPerSdkTeamSchedules()
        self.addTopHeaderWithButtonsInStack()
        self.addMonthViewAfterDelay()
        self.addTopShadow()
    }
    
    func setMonthArray(){
        for obj in self.teamScheduleArrayOfDictionary{
            for(key, value) in obj{
                self.monthsArray.append(key)
            }
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func addTopHeaderWithButtonsInStack(){
        centerMonthButton.addTarget(self, action: #selector(NCScheduleListView.centerMonthButtonClicked(_:)), for: .touchUpInside)
        centerMonthButton.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: UIFont.Weight.init(5))
        leftButton.setTitle("Left", for: .normal)
        leftButton.setImage(UIImage(named: "AddIcon"), for: .normal)
        leftButton.addTarget(self, action: #selector(NCScheduleListView.leftButtonClicked(_:)), for: .touchUpInside)
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        leftButton.width(constant: 30)
        leftButton.height(constant: 30)
        rightButton.setImage(UIImage(named: "Schedule"), for: .normal)
        rightButton.addTarget(self, action: #selector(NCScheduleListView.rightButtonClicked(_:)), for: .touchUpInside)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        rightButton.width(constant: 40)
        rightButton.height(constant: 40)
        rightButton.imageView?.contentMode = .scaleAspectFit
        let stackView = UIStackView(arrangedSubviews: [leftButton, centerMonthButton, rightButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        let leading = NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: topFixedHeaderView, attribute: .left, multiplier: 1, constant: 10)
        let trailing = NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: topFixedHeaderView, attribute: .right, multiplier: 1, constant: -10)
        let top = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: topFixedHeaderView, attribute: .top, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: stackView, attribute: .height , relatedBy: .equal, toItem: topFixedHeaderView, attribute: .height, multiplier: 1, constant: 0)
        topFixedHeaderView.addConstraints([leading, trailing, top, height])
        stackView.backgroundColor = UIColor.red
        topFixedHeaderView.addSubview(stackView)
    }
    
    @objc func centerMonthButtonClicked(_ sender: UIButton){
        if self.isFirstTimeMonthsShowing{
            self.createMonthCollectionView()
            self.isFirstTimeMonthsShowing = false
        }
        self.monthCollectionView.reloadData()
        self.shoulShowMonthsView = !self.shoulShowMonthsView
        self.monthCollHeight = self.headerSizeCache[self.selectedMonthIndex].height
        self.shouldShowMonthsCollectionView()
    }
    
    @objc func rightButtonClicked(_ sender: UIButton){
        self.shouldShowCalendar = !self.shouldShowCalendar
        self.rightButton.setImage(UIImage(named: self.shouldShowCalendar ? "Schedule" : "ListView"), for: .normal)
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.gameCollectionView.reloadData()
        }) { (bool) in
            self.shoulShowMonthsView = false
            if self.monthCollectionView != nil{
                self.monthCollectionView.reloadData()
                self.shouldShowMonthsCollectionView()
            }
        }
        
    }
    
    func shouldShowMonthsCollectionView(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.frameExapandableAnimateableView(shoulShow: self.shoulShowMonthsView ? true: false)
            self.monthCollectionView.frame = CGRect(x: 0, y: 0, width: self.expandableMonthView.frame.width, height: self.shoulShowMonthsView ? self.expandableMonthView.frame.height : 0)
        }) { (bool) in
        }
    }
    
    @objc func leftButtonClicked(_ sender: UIButton){
        
    }
    
    func updateMonthsCollParentFrameSize(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            self.frameExapandableAnimateableView(shoulShow: self.shoulShowMonthsView ? true: false)
            self.monthCollectionView.frame = CGRect(x: 0, y: 0, width: self.expandableMonthView.frame.width, height: self.shoulShowMonthsView ? self.expandableMonthView.frame.height : 0)
        }) { (bool) in
            
        }
    }
    
    
    
    func createMonthCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: monthCollectionCellWidth, height: 34)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        monthCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: expandableMonthView.frame.width, height: expandableMonthView.frame.height), collectionViewLayout: layout)
        if monthCollectionView.superview == nil{
            expandableMonthView.addSubview(monthCollectionView)
        }
        self.monthCollectionView.backgroundColor = headerAndMonthsBGcolor
        self.monthCollectionView.register(NCMonthCollectionCell.self, forCellWithReuseIdentifier: self.monthCellIdentifier)
        self.monthCollectionView.dataSource = self
        self.monthCollectionView.delegate = self
        self.reloadMonthCollectionVw()
        
    }
    
    func frameExapandableAnimateableView(shoulShow: Bool){
        expandableMonthView.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: shoulShow ? monthCollHeight : 0)
    }
    
    func reloadMonthCollectionVw(){
        monthCollectionView.reloadData()
    }
    
    func createViewAndAddSubview(){
        self.topFixedHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstarintsToTopHeaderView(parentView: self, myView: self.topFixedHeaderView)
        self.addSubview(topFixedHeaderView)
        self.topFixedHeaderView.backgroundColor = UIColor.lightGray
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.estimatedItemSize = CGSize(width: self.frame.width - 10, height: normalCellHeight)
        self.addTopShadow()
        self.gameCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width), collectionViewLayout: flowLayout)
        gameCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.gameCollectionView.alwaysBounceVertical = true
        self.addConstraintsToCollectionView(parentView: self, myView: gameCollectionView)
        self.addSubview(gameCollectionView)
        gameCollectionView.register(UINib(nibName: cellIdentifier , bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        gameCollectionView.register(UINib(nibName: "ScheduleHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ScheduleHeaderReusableView")
        gameCollectionView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
    }
    
    func addTopShadow(){
        let path = UIBezierPath(rect: self.topFixedHeaderView.frame)
        path.move(to: CGPoint(x: self.topFixedHeaderView.bounds.origin.x, y: self.topFixedHeaderView.frame.size.height))
        path.addLine(to: CGPoint(x: self.topFixedHeaderView.bounds.width / 2, y: self.topFixedHeaderView.bounds.height + 3.0))
        path.addLine(to: CGPoint(x: self.topFixedHeaderView.bounds.width, y: self.topFixedHeaderView.bounds.height))
        path.close()
        self.shadowView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstarintsToTopShadowView(parentView: self, myView: self.shadowView)
        
        self.addSubview(self.shadowView)
    }
    
    func addMonthViewAfterDelay(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.frameExapandableAnimateableView(shoulShow: false)
            self.expandableMonthView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            self.addSubview(self.expandableMonthView)
            self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.shadowView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
            self.shadowView.layer.shadowColor = UIColor.gray.cgColor
            self.shadowView.layer.shadowRadius = 5
            self.shadowView.layer.shadowOpacity = 0.8
            self.shadowView.layer.masksToBounds = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillMonthsAsPerSdkTeamSchedules(){
        self.setCenterMonthText(index: selectedIndexPath.row)
        self.centerMonthButton.tag = 0
        self.getSectionCGSizeForHeaders()
        self.gameCollectionView.dataSource = self
        self.gameCollectionView.delegate = self
        
        self.gameCollectionView.reloadData()
    }
    
    func addConstarintsToTopHeaderView(parentView: UIView, myView: UIView){
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1, constant: 0))
        myView.addConstraint(NSLayoutConstraint(item: myView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))

    }
    
    func addConstarintsToTopShadowView(parentView: UIView, myView: UIView){
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .top, relatedBy: .equal, toItem: topFixedHeaderView, attribute: .bottom, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1, constant: 0))
        myView.addConstraint(NSLayoutConstraint(item: myView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        
    }
    
    func addConstraintsToCollectionView(parentView: UIView, myView: UIView){
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .top, relatedBy: .equal, toItem: self.shadowView, attribute: .bottom, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: myView, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1, constant: 0))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.gameCollectionView){
            self.centerMonthClicked = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.gameCollectionView){
            scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
            if let firstIndexPath = self.gameCollectionView.indexPathsForVisibleItems.first{
                print("IndexPath section- \(firstIndexPath.section) row \(firstIndexPath.row)")
                if !self.centerMonthClicked{
                    self.setCenterMonthText(index: firstIndexPath.section)
                }
                self.selectedMonthIndex = firstIndexPath.section
                if self.shoulShowMonthsView{
                    self.monthCollHeight = self.headerSizeCache[self.selectedMonthIndex].height
                    self.updateMonthsCollParentFrameSize()
                    self.monthCollectionView.reloadData()
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.gameCollectionView){
            if let headerArray = self.gameCollectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader) as? [UICollectionReusableView]{
                scrollView.decelerationRate = 1
            }
        }
    }
    
    func setCenterMonthText(index: Int){
        UIView.animate(withDuration: 0.2) {
            self.centerMonthButton.setTitle(self.monthsArray[index], for: .normal)
        }        
    }
    
    func calculateHeaderHeightAsPerWeeksCount(noOfWeeks: Int) -> CGFloat {
        if noOfWeeks == 5 {
            return 183.0
        } else if noOfWeeks == 6 {
            return 215.0
        } else {
            return 150.0
        }
    }
    var headerSizeCache: [CGSize] = []
    func getSectionCGSizeForHeaders(){
        var size = CGSize.zero
        var arrSizes: [CGSize] = []
        for (index, _) in self.teamScheduleArrayOfDictionary.enumerated(){
            let dict: [String: [NCTeamScheduleModel]] = self.teamScheduleArrayOfDictionary[index]
            let scheduleArray = dict[self.monthsArray[index]]
            let monthYear = scheduleArray!.last!.gameDate!
            let model: DateModel = .init()
            let monthYearArray = monthYear.components(separatedBy: "-")
            let month    = Int(monthYearArray[1])
            let year     = Int(monthYearArray[0])
            let noOfWeeks = model.weeksInMonth(month: month!, year: year!)
            let ht = self.calculateHeaderHeightAsPerWeeksCount(noOfWeeks: noOfWeeks)
            size = CGSize(width: self.gameCollectionView.frame.width, height: ht)
            arrSizes.append(size)
        }
        headerSizeCache = arrSizes
    }
    var originalPoint: CGPoint!
    var oldSwipedIndexPath: IndexPath?
    @objc func swiped(_ recognizer: UIPanGestureRecognizer){
        let xDistance: CGFloat = recognizer.translation(in: self).x
        let locationInCollectionView: CGPoint = recognizer.location(in: self.gameCollectionView)
        let indexPathOfMovingCell = self.gameCollectionView.indexPathForItem(at: locationInCollectionView)
        let cell = self.gameCollectionView.cellForItem(at: indexPathOfMovingCell!) as! NCScheduleListCell
        var t = CGAffineTransform.identity
        switch recognizer.state {
        case .began:
            self.originalPoint = cell.wholeParentView.center
            if let oldSwiped = oldSwipedIndexPath{
                if let cell = self.gameCollectionView.cellForItem(at: oldSwiped) as? NCScheduleListCell{
                    self.resetViewPositionAndTransformations(cell: cell)
                }                
            }
        case .failed:
            print("failed")
        case .cancelled:
            print("cancelled")
        case .changed:
            oldSwipedIndexPath = indexPathOfMovingCell
            let translation: CGPoint = recognizer.translation(in: self)
            let displacement: CGPoint = CGPoint.init(x: translation.x, y: translation.y)
            if -displacement.x > self.originalPoint.x {
                let hasMovedToFarLeft = cell.wholeParentView.frame.maxX < UIScreen.main.bounds.width / 2
                if (hasMovedToFarLeft) {
                    stopViewAtPosWithAnimation(cell: cell)
                }
            }else if displacement.x + self.originalPoint.x < self.originalPoint.x {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    cell.wholeParentView.transform = CGAffineTransform.init(translationX: displacement.x, y: 0)
                    //cell.backgoundButton.transform = CGAffineTransform.init(scaleX: displacement.x / 100, y: displacement.x / 100)
                    cell.wholeParentView.center = CGPoint(x: self.originalPoint.x + xDistance, y: self.originalPoint.y)
                    cell.bgButtonsView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
                }, completion: { (bool) in
                })
                UIView.animate(withDuration: 0.5, animations: {
                    t = t.scaledBy(x: 1.2, y: 1.2)
                    cell.backgoundButton.transform = t
                })
            }
        case .ended:
            let hasMovedToFarLeft = cell.wholeParentView.frame.maxX < UIScreen.main.bounds.width / 2
            if (hasMovedToFarLeft) {
                stopViewAtPosWithAnimation(cell: cell)
                //resetViewPositionAndTransformations(cell: cell)
            } else {
                resetViewPositionAndTransformations(cell: cell)
            }
        default:
            break
        }
    }
    
    func resetViewPositionAndTransformations(cell: NCScheduleListCell){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations: {
            cell.wholeParentView.center = self.originalPoint
            cell.wholeParentView.transform = CGAffineTransform(rotationAngle: 0)
            cell.backgoundButton.transform = CGAffineTransform.identity
            cell.bgButtonsView.backgroundColor = UIColor.yellow.withAlphaComponent(1.0)
        }, completion: {success in })
    }
    
    func stopViewAtPosWithAnimation(cell: NCScheduleListCell) {
        var animations:(()->Void)!
        animations = {cell.wholeParentView.center.x = -cell.bounds.origin.x}
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations: {
            //cell.wholeParentView.center.x = -(cell.bounds.origin.x + 10)
        }, completion: {success in
            
        })
        
    }
    
}
 
 extension NCScheduleListView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.isEqual(self.gameCollectionView){
            if self.shouldShowCalendar {
                return self.headerSizeCache[section]
            } else {
                return CGSize.zero
            }
        }
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.isEqual(self.gameCollectionView){
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.isEqual(self.gameCollectionView){
            return CGSize(width: self.gameCollectionView.frame.width - gameCollectionView.contentInset.left - gameCollectionView.contentInset.right , height: normalCellHeight)
        }else{
            
        }
        return CGSize(width: monthCollectionCellWidth, height: 34)
    }
 }

extension NCScheduleListView: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.isEqual(gameCollectionView){
            return self.teamScheduleArrayOfDictionary.count
        }else{
            return 1
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         if collectionView.isEqual(gameCollectionView){
            let headerView: ScheduleHeaderReusableView = collectionView.dequeueReusableSupplementaryView(forSupplementaryViewOfKind: kind, forIndexPath: indexPath)
            headerView.backgroundColor = UIColor.blue;
            let dict: [String: [NCTeamScheduleModel]] = self.teamScheduleArrayOfDictionary[indexPath.section]
            let scheduleArray = dict[self.monthsArray[indexPath.section]]
            let monthYear = scheduleArray!.last!.gameDate!
            let calendarView = NBAScheduleCalenderView(frame: headerView.bounds, monthYear: monthYear, scheduleArray: scheduleArray!, selectedGameIndexPath: selectedIndexPath, isFirstTime: true, indexPath: indexPath)
            headerView.addSubview(calendarView)
            calendarView.delegate = self
            return headerView
         }else{
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(gameCollectionView){
            let dict: [String: [NCTeamScheduleModel]] = self.teamScheduleArrayOfDictionary[section]
            let scheduleArray = dict[self.monthsArray[section]]
            return scheduleArray!.count
        }else{
            return self.monthsArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isEqual(monthCollectionView){            
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(gameCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NCScheduleListCell
            let dict: [String: [NCTeamScheduleModel]] = self.teamScheduleArrayOfDictionary[indexPath.section]
            let scheduleArray = dict[self.monthsArray[indexPath.section]]
            cell.setGameScheduleData(teamScheduleModel: scheduleArray![indexPath.row] , indexPath: indexPath)
            cell.setupSwipeGesture(delegate: self)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: monthCellIdentifier, for: indexPath) as! NCMonthCollectionCell
            cell.indexPath = indexPath
            cell.updateData(month: self.monthsArray[indexPath.item], indexPath: indexPath, selectedIndexPath: IndexPath(item: self.selectedMonthIndex, section: 0))
            return cell
        }
    }
}
 
 extension NCScheduleListView: CalendarViewDelegate{
    func selectedDate(parentIndexPath: IndexPath, rowInCollection: Int) {
        self.gameCollectionView.scrollToItem(at: parentIndexPath, at: .centeredVertically, animated: true)
    }
    
 }
 
 extension NCScheduleListView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(monthCollectionView){
            collectionView.reloadData()
            self.selectedMonthIndex = indexPath.item
            self.centerMonthClicked = true
            self.setCenterMonthText(index: indexPath.item)
            //self.frameExapandableAnimateableView(shoulShow: true)
            self.gameCollectionView.scrollToItem(at: IndexPath(item: 0 , section: indexPath.item), at: .centeredVertically, animated: true)
        }else{
            //Team Schedule tapped
        }
    }
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
       return true
    }
 }
 
 extension NCScheduleListView: UIGestureRecognizerDelegate{
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: self.gameCollectionView)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print(gestureRecognizer)
        print(otherGestureRecognizer)
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: self.gameCollectionView)
            if fabs(translation.x) > 0 {
                
                //return true
            }else if fabs(translation.x) < 0{
                //return true
            }
            return false
        }else if let scrollGesture = gestureRecognizer.view as? UICollectionView{
            return false
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
 }
