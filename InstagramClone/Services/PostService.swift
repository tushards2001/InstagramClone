//
//  PostService.swift
//  InstagramClone
//
//  Created by MacBookPro on 1/31/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else { return }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        let currentUser = User.current
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("posts").child(String(describing: currentUser.uid)).childByAutoId()
        let newPostKey = newPostRef.key
        
        UserService.followers(for: currentUser) { (FollowerUIDs) in
            let timelinePostDict = ["poster_uid": currentUser.uid]
            
            var updatedData: [String: Any] = ["timeline/\(String(describing: currentUser.uid!))/\(newPostKey)": timelinePostDict]
            
            for uid in FollowerUIDs {
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
            }
            
            let postDict = post.dictValue
            
            updatedData["posts/\(currentUser.uid!)/\(newPostKey)"] = postDict

            rootRef.updateChildValues(updatedData)
        }
    }
    
    
    static func show(forKey postKey: String, posterUID: String, completion: @escaping(Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child(posterUID).child(postKey)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
            LikeService.isPostLiked(for: post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        }
    }
    
}
