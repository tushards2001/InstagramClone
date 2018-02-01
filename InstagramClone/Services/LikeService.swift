//
//  LikeService.swift
//  InstagramClone
//
//  Created by MacBookPro on 2/1/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import Foundation
import  FirebaseDatabase

class LikeService {
    
    static func create(for post: Post, success: @escaping(Bool) -> Void) {
        guard let key = post.key else {
            return success(false)
        }
        
        let currentId = User.current.uid!
        
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentId)
        
        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid!).child(key).child("like_count")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount + 1
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return success(false)
                } else {
                    return success(true)
                }
            })
        }
    }
    
    static func delete(for post: Post, success: @escaping(Bool) -> Void) {
        guard let key = post.key else {
            return success(false)
        }
        
        let currentId = User.current.uid!
        
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentId)
        
        likesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid!).child(key).child("like_count")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount - 1
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return success(false)
                } else {
                    return success(true)
                }
            })
        }
    }
    
    static func isPostLiked(for post: Post, byCurrentUserWithCompletion completion: @escaping(Bool) -> Void) {
        guard  let postKey = post.key else {
            assertionFailure("Error: Post must have a key")
            return completion(false)
        }
        
        let likesRef = Database.database().reference().child("postLikes").child(postKey)
        
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? [String: Bool] {
                return completion(true)
            } else {
                return completion(false)
            }
        }
    }
    
    static func setIsLiked(_ isLiked: Bool, for post: Post, success:@escaping(Bool) -> Void) {
        if isLiked {
            create(for: post, success: success)
        } else {
            delete(for: post, success: success)
        }
    }
    
}















