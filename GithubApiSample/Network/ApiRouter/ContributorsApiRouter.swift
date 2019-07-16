//
//  PushApiRouter.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation
import Alamofire

protocol ContributorsApiRouter: ApiRouter {
    func contributorsForRepository(_ repository: String,
                                   of owner: String,
                                   offset: Int,
                                   itemsPerPage: Int,
                                   completion: @escaping RequestCompletion<ArrayResponse<Contributor>>)
}

extension ContributorsApiRouter where Self: ContributorsApiRouter {
    var apiGroupPath: String { return "repos/%@/%@/contributors" }

    func contributorsForRepository(_ repository: String,
                                   of owner: String,
                                   offset: Int,
                                   itemsPerPage: Int,
                                   completion: @escaping RequestCompletion<ArrayResponse<Contributor>>) {
        let path = String(format: apiGroupPath, owner, repository)
        
        let page = offset / itemsPerPage
        let params: Parameters = ["page" : page, "per_page" : itemsPerPage]
        
        request(path: path, parameters: params) { (result: RequestResult<ArrayResponse<Contributor>>) in
            completion(result)
        }
    }
}
