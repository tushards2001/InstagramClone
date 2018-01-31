//
//  MainTabBarController.swift
//  InstagramClone
//
//  Created by MacBookPro on 1/31/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let photoHelper = IGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            PostService.create(for: image)
        }
        
        delegate = self
        tabBar.unselectedItemTintColor = .black
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            photoHelper.presentActionSheet(from: self)
            return false
        } else {
            return true
        }
    }
}
