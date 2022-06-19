//
//  NowPlayingCollectionViewCell.swift
//  MobilliumDemo
//
//  Created by Metilli on 31.03.2022.
//

import UIKit
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(imageURL: String?, title: String?, description: String?){
        
        if let imageURL = imageURL {
            ImageLoader().loadImage(with: imageURL, image: posterImageView)

        }
        if let title = title {
            titleLabel.text = title
        }
        
        if let description = description {
            descriptionLabel.text = description
        }
    }
}
