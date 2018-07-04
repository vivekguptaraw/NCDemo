//
//  DeeplinkManager.swift
//  NCDemo
//
//  Created by Vivek Gupta on 28/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import Foundation

enum StoryBoard: String {
    case FirstTabBar
    
    var Identifier: String {
        switch self {
        case .FirstTabBar:
            return "FirstTabBar"
        }
    }
}

enum DeeplinkPath {
    enum PresentationStyle {
        case push
        case present
    }
}

