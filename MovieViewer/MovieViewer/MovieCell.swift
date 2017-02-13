//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Nick Hasjim on 2/2/17.
//  Copyright © 2017 Nick Hasjim. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let fontSize: CGFloat = selected ? 34.0 : 17.0
        self.titleLabel?.font = self.textLabel?.font.withSize(fontSize)
        
        // Configure the view for the selected state
    }

}
