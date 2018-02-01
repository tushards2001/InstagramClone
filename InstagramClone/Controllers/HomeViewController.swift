//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by MacBookPro on 1/31/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    var posts = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Feed"
        
        configureTableView()
        
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        
        // remove separators from cells
        tableView.separatorStyle = .none
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 0.5)
        
        let post = posts[indexPath.row]
        let imageUrl = URL(string: post.imageURL)
        cell.postImageView.kf.setImage(with: imageUrl)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        return post.imageHeight
    }
    
}
