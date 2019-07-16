//
//  UsersApiRouter.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation
import Alamofire

protocol UsersApiRouter: ApiRouter {
    func detailsFor(_ contributor: Contributor,
                    completion: @escaping RequestCompletion<ObjectResponse<ContributorDetails>>)
}

extension UsersApiRouter where Self: UsersApiRouter {
    var apiGroupPath: String { return "users/%@" }
    
    func detailsFor(_ contributor: Contributor,
                    completion: @escaping RequestCompletion<ObjectResponse<ContributorDetails>>) {
        let path = String(format: apiGroupPath, contributor.username)
        
        request(path: path) { (result: RequestResult<ObjectResponse<ContributorDetails>>) in
            completion(result)
        }
    }
}
