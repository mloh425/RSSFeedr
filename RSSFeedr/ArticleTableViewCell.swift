//
//  ArticleTableViewCell.swift
//  RSSFeedr
//
//  Created by Sau Chung Loh on 9/14/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
