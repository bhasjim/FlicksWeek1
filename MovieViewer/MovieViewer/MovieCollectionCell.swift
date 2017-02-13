//
//  MovieCollectionCellCollectionViewCell.swift
//  MovieViewer
//
//  Created by Nick Hasjim on 2/7/17.
//  Copyright © 2017 Nick Hasjim. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    var highlightView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        //You Code here

        self.highlightView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(frame.size.width), height: CGFloat(frame.size.height)))
        self.highlightView.backgroundColor = UIColor.black
        self.highlightView.alpha = 0
        self.contentView.addSubview(self.highlightView)
    }

    
}
