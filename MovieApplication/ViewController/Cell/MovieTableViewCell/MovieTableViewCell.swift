//
//  UpcomingTableViewCell.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView(){
        posterImageView.layer.cornerRadius = 8
        titleLabel.font = UIFont(name: "SFProText-Bold", size: 15)
        selectionStyle = .none
    }
    
    func configure(imageURL: String?, title: String?, description: String?, date: String?){
        
        if let imageURL = imageURL {
            ImageLoader().loadImage(with: imageURL, image: posterImageView)

        }
        if let title = title {
            titleLabel.text = title
        }
        
        if let description = description {
            descriptionLabel.text = description
        }
        
        if let date = date {
            dateLabel.text = date.convertDateFormat
        }
    }
}
