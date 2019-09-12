//
//  MovieCollectionViewCell.swift
//  MovieViewer
//
//  Created by Dustyn August on 1/22/16.
//  Copyright © 2016 ccsfcomputers. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterCollectionView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterCollectionView.layer.cornerRadius = 2.0
        posterCollectionView.clipsToBounds = true
        
        // Initialization code
//        contentView.layer.cornerRadius = 66.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
}
