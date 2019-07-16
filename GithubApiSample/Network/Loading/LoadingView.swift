//
//  LoadingView.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

protocol LoadingView: class, LoadingProtocol {}

extension LoadingView {
    func loadingStarted() {
        if let progress = self as? ProgressHUDView {
            progress.showHud(withTitle: nil, subtitle: nil)
        }
    }
    
    func loadingFinished(state: LoadedState) {
        loadingFinished(state: state, completion: nil)
    }
    
    func loadingFinished(state: LoadedState, completion: EmptyCallback? ) {
        if let progress = self as? ProgressHUDView {
            if case .failed(_) = state {
                progress.hideHud(isSucces: false) { [weak self] in
                    self?.showToastIfNeeded(state: state, completion: completion)
                }
            } else {
                progress.hideHud(isSucces: true, completion: completion)
            }
        } else {
            showToastIfNeeded(state: state, completion: completion)
        }
    }
    
    func showToastIfNeeded(state: LoadedState, completion: EmptyCallback?) {
        if let toast = self as? ToastMessageView, case .failed(let error) = state {
            let message = error?.description ?? "OOoopss... somethings went wrong"
            toast.show(message: message) { (tapped) in completion?() }
        } else {
            completion?()
        }
    }
}
