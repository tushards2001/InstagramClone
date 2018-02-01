//
//  FollowService.swift
//  InstagramClone
//
//  Created by MacBookPro on 2/1/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FollowService {
    
    private static func followUser(_user user: User, forCurrentUserWithSuccess success:@escaping(Bool) -> Void) {
        let currentUID = User.current.uid
        let followData = ["followers/\(String(describing: user.uid))/\(String(describing: currentUID))" : true,
                          "following/\(String(describing: currentUID))/\(String(describing: user.uid))" : true]
        
        let ref = Database.database().reference()
        
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            return success(error == nil)
        }
    }
    
    private static func unfollowUser(_user user: User, forCurrentUserWithSuccess success:@escaping(Bool) -> Void) {
        let currentUID = User.current.uid
        let followData = ["followers/\(String(describing: user.uid))/\(String(describing: currentUID))" : NSNull(),
                          "following/\(String(describing: currentUID))/\(String(describing: user.uid))" : NSNull()]
        
        let ref = Database.database().reference()
        
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            return success(error == nil)
        }
    }
    
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping(Bool) -> Void) {
        if isFollowing {
            followUser(_user: followee, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(_user: followee, forCurrentUserWithSuccess: success)
        }
    }
    
    static func isUserFollowed(_user user: User, byCurrentUserWithCompletion completion: @escaping(Bool) -> Void) {
        let currentUID = User.current.uid
        
        let ref = Database.database().reference().child("followers").child(user.uid!)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? [String: Any] {
                return completion(true)
            } else {
                return completion(false)
            }
        }
    }
}
