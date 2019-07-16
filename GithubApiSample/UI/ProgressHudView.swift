//
//  ProgressHudView.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import JGProgressHUD

protocol ProgressHUDView {
    func showHud(withTitle title: String?, subtitle: String?)
    
    func hideHud(isSucces: Bool, completion: EmptyCallback?)
    func hideHud(animated: Bool)
}

extension ProgressHUDView {
    fileprivate var window: UIWindow? { return UIApplication.shared.delegate?.window ?? nil }
    fileprivate var hudTag: Int { return 0x517 }
    fileprivate var hud: JGProgressHUD {
        if let hud = window?.viewWithTag(hudTag) as? JGProgressHUD {
            return hud
        }
        
        let hud = JGProgressHUD(style: .extraLight)
        hud.tag = hudTag
        return hud
    }
    
    func showHud(withTitle title: String? = nil, subtitle: String? = nil) {
        DispatchQueue.main.async {
            guard let window = self.window else { return }
            self.hud.show(in: window, animated: true)
        }
    }
    
    func hideHud(isSucces: Bool, completion: EmptyCallback? = nil) {
        if !isSucces {
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
        }
        
        let delay: TimeInterval = 0.35
        DispatchQueue.main.async {
            self.hud.dismiss(afterDelay: delay, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay + 0.1) { completion?() }
        }
    }
    
    func hideHud(animated: Bool) {
        DispatchQueue.main.async { self.hud.dismiss(animated: animated) }
    }
}
