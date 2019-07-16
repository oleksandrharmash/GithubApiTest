//
//  Environment.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import AlamofireNetworkActivityIndicator

#if DEVELOPMENT
import AlamofireNetworkActivityLogger
#endif

class Environment {
    static func start() {
        #if DEVELOPMENT
        NetworkActivityLogger.shared.level = .debug
        //don't print objects more than 500 bytes
        NetworkActivityLogger.shared.filterPredicate = NSPredicate(block: { (object, value) -> Bool in
            guard let obj = object as? URLRequest,
                let count = obj.httpBody?.count
                else { return false }
            return count > 500
        })
        
        NetworkActivityLogger.shared.startLogging()
        #endif
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
}
