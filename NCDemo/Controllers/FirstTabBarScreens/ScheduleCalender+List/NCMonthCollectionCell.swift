//
//  NCMonthCollectionCell.swift
//  DynamicUIDemo
//
//  Created by Vivek Gupta on 08/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import UIKit

class NCMonthCollectionCell: UICollectionViewCell {
    
    var monthLabel: UILabel = UILabel()
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    var shouldShowBorder: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(monthLabel)
        self.backgroundColor = headerAndMonthsBGcolor
        self.monthLabel.textAlignment = .center
        self.monthLabel.font = UIFont.systemFont(ofSize: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(month: String, indexPath: IndexPath, selectedIndexPath: IndexPath){
        self.indexPath = indexPath
        self.monthLabel.text = month
        if self.indexPath.item == selectedIndexPath.item{
            shouldShowBorder = true
        }else{
            shouldShowBorder = false
        }
        self.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shouldShowBorder = false
        self.monthLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        monthLabel.sizeToFit()
        monthLabel.frame.size = self.frame.size
        monthLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        if shouldShowBorder{
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.red.cgColor
        }else{
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.white.cgColor
        }
    }
}
