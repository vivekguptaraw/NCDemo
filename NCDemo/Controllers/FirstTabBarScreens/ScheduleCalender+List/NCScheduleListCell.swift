//
//  NCScheduleListCell.swift
//  DynamicUIDemo
//
//  Created by Vivek Gupta on 07/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import UIKit

class NCScheduleListCell: UICollectionViewCell {
    @IBOutlet weak var visitorScoreLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var visitorTeamName: UILabel!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var visitorTeamImage: UIImageView!
    @IBOutlet weak var homeTeamImage: UIImageView!
    
    @IBOutlet weak var finalLabel: UILabel!
    @IBOutlet weak var daysConstantLabel: UILabel!
    @IBOutlet weak var hrsConstantLabel: UILabel!
    @IBOutlet weak var minConstantLabel: UILabel!
    
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var hrsCountLabel: UILabel!
    @IBOutlet weak var minCountLabel: UILabel!
    
    @IBOutlet weak var dhmTimerView: UIView!
    
    @IBOutlet weak var buyTicketButton: UIButton!
    
    @IBOutlet var channelNameToBuyTicketConstraint: NSLayoutConstraint!
    
    @IBOutlet var channelNameToBottomLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var homeAwayLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgoundButton: UIButton!
    
    var swipeGesture: UIPanGestureRecognizer!
    var originalPoint:CGPoint!
    
    @IBOutlet weak var backButtonHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var backButtonWidthConstraint: NSLayoutConstraint!
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var buyTicketUrlString: String?
    @IBOutlet weak var wholeParentView: UIView!
    @IBOutlet weak var bgButtonsView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setGameScheduleData(teamScheduleModel: NCTeamScheduleModel, indexPath: IndexPath){
        self.indexPath = indexPath
        if let url = teamScheduleModel.buyTickets, !url.isEmpty {
            buyTicketUrlString = url
            buyTicketButton.isHidden = false
            channelNameToBuyTicketConstraint.isActive = true
            channelNameToBottomLayoutConstraint.isActive = false
            dhmTimerView.isHidden = false
            dateLabel.isHidden = true
            finalLabel.isHidden = true
            visitorScoreLabel.text = teamScheduleModel.visitor?.teamName
            homeScoreLabel.text = teamScheduleModel.home?.teamName
            visitorTeamName.isHidden = true
            homeTeamName.isHidden = true
        }else{
            buyTicketButton.isHidden = true
            channelNameToBuyTicketConstraint.isActive = false
            channelNameToBottomLayoutConstraint.isActive = true
            dhmTimerView.isHidden = true
            dateLabel.isHidden = false
            finalLabel.isHidden = false
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dt = formatter.string(from: teamScheduleModel.gameIsoDate!.getDatePerCurrentTimeZone()!)
            dateLabel.text = dt
            visitorScoreLabel.text = teamScheduleModel.visitor?.score
            homeScoreLabel.text = teamScheduleModel.home?.score
            visitorTeamName.isHidden = false
            homeTeamName.isHidden = false
        }
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    //MARK: In case we need to dynamically adjust the cell layout, we should take care of this func
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        // Customize the cell layout
    }
    
    func updateConstraintsAsPerButton(indexPath: IndexPath,  isBuyTkt: Bool){
        
        if isBuyTkt{
            
            
        }else{
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeGestureRecognizer(self.swipeGesture)
    }
    
    @IBAction func buyTicketClicked(_ sender: UIButton) {
        print(self.buyTicketUrlString)
    }
    
    func setupSwipeGesture(delegate: UIGestureRecognizerDelegate){
        self.swipeGesture = UIPanGestureRecognizer(target: delegate, action: #selector(NCScheduleListView.swiped(_:)))
        self.swipeGesture.delegate = delegate
        self.wholeParentView.addGestureRecognizer(swipeGesture)
    }
    
//    @objc func swiped(_ recognizer: UIPanGestureRecognizer){
//        let xDistance: CGFloat = recognizer.translation(in: self).x
//        switch recognizer.state {
//        case .began:
//            self.originalPoint = self.center
//        case .changed:
//            let translation: CGPoint = recognizer.translation(in: self)
//            let displacement: CGPoint = CGPoint.init(x: translation.x, y: translation.y)
//            
//            if displacement.x + self.originalPoint.x < self.originalPoint.x {
//                self.transform = CGAffineTransform.init(translationX: displacement.x, y: 0)
//                self.center = CGPoint(x: self.originalPoint.x + xDistance, y: self.originalPoint.y)
//            }
//        case .ended:
//            let hasMovedToFarLeft = self.frame.maxX < UIScreen.main.bounds.width / 2
//            if (hasMovedToFarLeft) {
//                removeViewFromParentWithAnimation()
//            } else {
//                resetViewPositionAndTransformations()
//            }
//        default:
//            break
//        }
//    }
//    
//    func resetViewPositionAndTransformations(){
//        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations: {
//            self.center = self.originalPoint
//            self.transform = CGAffineTransform(rotationAngle: 0)
//        }, completion: {success in })
//    }
//    
//    func removeViewFromParentWithAnimation() {
//        var animations:(()->Void)!
//        animations = {self.center.x = -self.frame.width}
//        
//        UIView.animate(withDuration: 0.2, animations: animations , completion: {success in self.removeFromSuperview()})
//    }
}

