//
//  PostActionCell.swift
//  InstagramClone
//
//  Created by MacBookPro on 2/1/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit

protocol PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}

class PostActionCell: UITableViewCell {
    
    static let height: CGFloat = 46
    
    var delegate: PostActionCellDelegate?
    
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
