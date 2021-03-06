//
//  UserService.swift
//  InstagramClone
//
//  Created by MacBookPro on 1/30/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, username: String, completion: @escaping(User?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    
    static func show(forUID uid: String, completion: @escaping(User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            return completion(user)
        }
    }
    
    static func posts(for user: User, completion: @escaping([Post]) -> Void) {
        let ref = Database.database().reference().child("posts").child(user.uid!)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            let posts: [Post] = snapshot.reversed().flatMap {
                guard let post = Post(snapshot: $0) else { return nil }
                
                dispatchGroup.enter()
                
                LikeService.isPostLiked(for: post, byCurrentUserWithCompletion: { (isLiked) in
                    post.isLiked = isLiked
                    
                    dispatchGroup.leave()
                })
                
                return post
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        }
    }
    
    
    static func usersExcludingCurrentUser(completion: @escaping([User]) -> Void) {
        let currentUser = User.current
        
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let users = snapshot.flatMap(User.init).filter{ $0.uid != currentUser.uid }
            
            let dispatchGroup = DispatchGroup()
            
            users.forEach{(user) in
                dispatchGroup.enter()
                
                FollowService.isUserFollowed(_user: user) {(isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        }
    }
    
    
    static func followers(for user: User, completion: @escaping([String]) -> Void) {
        let followersRef = Database.database().reference().child("followers").child(user.uid!)
        
        followersRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let followersDict = snapshot.value as? [String: Bool] else {
                return completion([])
            }
            
            let followersKeys = Array(followersDict.keys)
            return completion(followersKeys)
        }
    }
    
    static func timeline(completion: @escaping ([Post]) -> Void) {
        let currentUser = User.current
        
        let timelineRef = Database.database().reference().child("timeline").child(String(describing: currentUser.uid))
        timelineRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let dispatchGroup = DispatchGroup()
            
            var posts = [Post]()
            
            for postSnap in snapshot {
                guard let postDict = postSnap.value as? [String : Any],
                    let posterUID = postDict["poster_uid"] as? String
                    else { continue }
                
                dispatchGroup.enter()
                
                PostService.show(forKey: postSnap.key, posterUID: posterUID) { (post) in
                    if let post = post {
                        posts.append(post)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts.reversed())
            })
        })
    }
}























