//
//  DataLoadingState.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

// - none: initial state, loading not started yet
// - loading: Loading in process
// - loaded: Loading finished
enum LoadingState {
    case none
    case loading
    case loaded(LoadedState)
}

// - success: Loading finished successefully
// - failed: Loading finished with error; description - error description
enum LoadedState {
    case success
    case failed(error: FailReason?)
}
