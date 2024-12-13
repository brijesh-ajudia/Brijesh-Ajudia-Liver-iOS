//
//  CommentTVCell.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import UIKit

class CommentTVCell: UITableViewCell {
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblComment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
