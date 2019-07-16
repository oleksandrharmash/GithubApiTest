//
//  FailReason.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Foundation

struct FailReason {
    let description: String

    init(description: String) {
        self.description = description
    }
}

extension FailReason: Decodable {
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decode(String.self, forKey: .message)
    }
    
}
