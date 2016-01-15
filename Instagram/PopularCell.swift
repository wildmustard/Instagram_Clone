//
//  PopularCell.swift
//  Instagram
//
//  Created by John Henning on 1/14/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit

class PopularCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var usernameView: UITextView!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
