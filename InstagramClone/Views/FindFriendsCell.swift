//
//  FindFriendsCell.swift
//  InstagramClone
//
//  Created by MacBookPro on 2/2/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit

protocol FindFriendsCellDelegate {
    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell)
}

class FindFriendsCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate: FindFriendsCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 6
        followButton.clipsToBounds = true
        
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        delegate?.didTapFollowButton(sender, on: self)
    }
    

}
