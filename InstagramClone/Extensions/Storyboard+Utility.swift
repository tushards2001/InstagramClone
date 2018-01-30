//
//  Storyboard+Utility.swift
//  InstagramClone
//
//  Created by MacBookPro on 1/30/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum IGType: String {
        case main
        case login
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: IGType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: IGType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }
    
}
