//
//  ArrayResponse.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation

struct ArrayResponse<T: Decodable>: BaseResponse {
    var items: [T]?
    
    init(data: Data) throws {
        items = try JSONDecoder().decode([T].self, from: data)
    }
}
