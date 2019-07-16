//
//  RequestResult.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

enum RequestResult<T: BaseResponse> {
    case success(data: T?)
    case fail(error: FailReason)
}

extension RequestResult {
    var loadedState: LoadedState {
        if case .fail(let error) = self {
            return .failed(error: error)
        }
        return .success
    }
}
