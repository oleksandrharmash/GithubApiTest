//
//  ApiProvider.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation

import Alamofire

class ApiProvider: ContributorsApiRouter, UsersApiRouter {
    static let shared: ApiProvider = ApiProvider()
    
    lazy var sessionManager: SessionManager = {
        let manager = SessionManager()
        manager.adapter = GASRequestAdapter()
        return manager
    }()
    
    lazy var baseURL: String = {
       return Config.baseURL
    }()
    
    lazy var apiRelativePath: String = {
        return baseURL
    }()

    init() {}
}
