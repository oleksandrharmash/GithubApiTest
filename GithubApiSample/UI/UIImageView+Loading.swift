//
//  UIImageView+Loading.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import UIKit
import AlamofireImage

enum PlaceholderType {
    case none
    case avatar
}

private extension PlaceholderType {
    var image: UIImage? {
        switch self {
        case .none:
            return nil
        case .avatar:
            return #imageLiteral(resourceName: "AvatarPlaceholder")
        }
    }
}

extension UIImageView {
    func setImage(withUrlPath path: String?, withActivity: Bool = true,
                  placeholer: PlaceholderType) {
        guard let path = path,
            let url = URL(string: path) else {
                image = placeholer.image
                removeActivity()
                return
        }
        
        setImageForUrl(url, withActivity: withActivity, placeholder: placeholer.image)
    }
}

private extension UIImageView {
    private var activityTag: Int {
        return 0xff73
    }
    
    private var existingActivity: UIActivityIndicatorView? {
        return viewWithTag(activityTag) as? UIActivityIndicatorView
    }
    
    func setImageForUrl(_ url: URL, withActivity: Bool, placeholder: UIImage?) {
        DispatchQueue.main.async { self.addActivity() }
        af_setImage(withURL: url, placeholderImage: placeholder, imageTransition: .noTransition) {[weak self] (response) in
            self?.removeActivity()
        }
    }
    
    func removeActivity() {
        DispatchQueue.main.async {
            self.existingActivity?.removeFromSuperview()
        }
    }
    
    func addActivity() {
        if let activity = existingActivity {
            bringSubviewToFront(activity)
            return
        }
        
        let style: UIActivityIndicatorView.Style
        if bounds.width > 50 { style = .whiteLarge }
        else { style = .gray }
        
        let activity = UIActivityIndicatorView(style: style)
        activity.startAnimating()
        activity.color = .darkGray
        activity.tag = activityTag
        addSubview(activity)
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
