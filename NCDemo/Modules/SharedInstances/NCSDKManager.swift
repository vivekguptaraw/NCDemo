//
//  NCSDKManager.swift
//  NCDemo
//
//  Created by Vivek Gupta on 28/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import Foundation

class NCSDKManager: NSObject{
    
    static var shared: NCSDKManager = NCSDKManager()
    var queryManager: NCQueryManager?
    
    private override init() {
        let sportsManager = NCSportsManger.init(activateService: [.ALL])
        self.queryManager = sportsManager.queryManager
    }
}
