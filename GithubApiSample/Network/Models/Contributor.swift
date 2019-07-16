//
//  Contributor.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation

struct Contributor: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case avatar = "avatar_url"
        case username = "login"
        case commits = "contributions"
    }
    
    let id: Int
    let avatar: String
    let username: String
    let commits: Int
}

struct ContributorDetails: Decodable {
    let location: String
}
