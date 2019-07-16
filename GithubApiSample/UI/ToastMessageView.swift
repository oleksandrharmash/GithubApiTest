//
//  ToastMessageView.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import UIKit
import Toast_Swift

typealias ToastCompletion = ((_ isTapped: Bool)->())

protocol ToastMessageView {
    func show(message: String?, withTitle title:String?, position: ToastPosition, completion: ToastCompletion?)
}

extension ToastMessageView {
    func show(message: String, withTitle title: String? = nil, completion: ToastCompletion? = nil) {
        self.show(message: message, withTitle: title, position: .bottom, completion: completion)
    }
}

extension ToastMessageView where Self: UIViewController {
    func show(message: String?, withTitle title: String? = nil, position: ToastPosition = .bottom, completion: ToastCompletion? = nil) {
        DispatchQueue.main.async {
            self.view.makeToast(message, position: position, title: title, completion: completion)
        }
    }
}
