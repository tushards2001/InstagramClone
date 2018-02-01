//
//  PostHeaderCell.swift
//  InstagramClone
//
//  Created by MacBookPro on 2/1/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let height: CGFloat = 54
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        
    }
    
}
