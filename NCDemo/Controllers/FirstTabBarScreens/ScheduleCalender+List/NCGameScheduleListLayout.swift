//
//  NCGameScheduleListLayout.swift
//  DynamicUIDemo
//
//  Created by Vivek Gupta on 07/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import Foundation
protocol NCGameScheduleListLayoutDelegate: NSObjectProtocol {
    func collectionViewheightForHeader(indexPath: IndexPath) -> CGFloat
    func collectionViewHeightforCell(indexPath: IndexPath) -> CGFloat
}

class NCGameScheduleListLayout: UICollectionViewFlowLayout {
    private var cache           = [UICollectionViewLayoutAttributes]()
    private var headerViewCache = [IndexPath: UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat   = 0.0
    var showHeaderView: Bool      = true
    var headerScrollX: CGFloat  = 20
    weak var delegate: NCGameScheduleListLayoutDelegate?
    
    override init() {
        super.init()
        self.sectionHeadersPinToVisibleBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        super.prepare()
        self.cache.removeAll()
        self.headerViewCache.removeAll()
        contentHeight = 0.0
        var count = 0
        var indexOfHeader = 0
        for section in 0..<collectionView!.numberOfSections {
            for cellIndex in 0..<collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: cellIndex, section: section)
                count += 1
                if let dlg = self.delegate {
                    let headerHeight = dlg.collectionViewheightForHeader(indexPath: indexPath)
                    if headerHeight > 0 {
                        if indexOfHeader == 0 {
                            indexOfHeader = count
                        }
                        if fmod(Double(count - indexOfHeader), 12.0) == 0 {
                            let frame = CGRect(origin: CGPoint(x: 0, y: contentHeight), size: CGSize(width: collectionView!.frame.width, height: headerHeight))
                            let insetFrame = frame.insetBy(dx: 1, dy: 1)
                            let headerAtt = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
                            headerAtt.frame = insetFrame
                            headerViewCache[indexPath] = headerAtt
                            contentHeight = max(contentHeight, frame.maxY)
                        }
                    }
                    let frame = CGRect(origin: CGPoint(x: 0, y: contentHeight), size: CGSize(width: collectionView!.frame.width, height: dlg.collectionViewHeightforCell(indexPath: indexPath)))
                    let insetFrame = frame.insetBy(dx: 1, dy: 1)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    contentHeight = max(contentHeight, frame.maxY)
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize  {
        return CGSize(width: contentWidth, height: (contentHeight < self.collectionView!.frame.height ? self.collectionView!.frame.height + (20): contentHeight))
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            layoutAttributes.append(attributes)
        }
        for attributes in headerViewCache.keys {
            layoutAttributes.append(headerViewCache[attributes]!)
        }
        return layoutAttributes
    }
    
    deinit {
        self.delegate = nil
    }
}
