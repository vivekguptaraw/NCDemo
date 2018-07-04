//
//  UIView+Refactoring.swift
//  NCDemo
//
//  Created by Vivek Gupta on 28/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//



import Foundation
import UIKit

protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: NibLoadableView { }
extension UITableViewHeaderFooterView: NibLoadableView { }
//extension UICollectionViewCell: NibLoadableView { }
extension UICollectionReusableView: NibLoadableView { }

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }
//extension UICollectionViewCell: ReusableView { }
extension UICollectionReusableView: ReusableView { }
