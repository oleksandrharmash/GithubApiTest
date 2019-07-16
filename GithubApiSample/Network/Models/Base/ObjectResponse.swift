//
//  ObjectResponse.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation

struct ObjectResponse<T: Decodable>: BaseResponse {
    var item: T?
    
    init(data: Data) throws {
        item = try JSONDecoder().decode(T.self, from: data)
    }
}
