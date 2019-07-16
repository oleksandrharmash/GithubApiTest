//
//  BaseResponse.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation

protocol BaseResponse {
    init (data: Data) throws
}
