//
//  Config.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation

struct Config {
    static var baseURL: String = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
    
    static var gitToken: String = Bundle.main.object(forInfoDictionaryKey: "GIT_TOKEN") as! String
}
