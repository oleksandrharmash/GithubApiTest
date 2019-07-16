//
//  GASRequestAdapter.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Alamofire

class GASRequestAdapter: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {

        var urlRequest = urlRequest
        urlRequest.setValue("token \(Config.gitToken)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
}
