//
//  FileCell.swift
//  Pods
//
//  Created by Ренат Рахматуллин on 26.04.2021.
//

import UIKit

class FileCell: UITableViewCell {

    var imageView = UIImageView()
    var nameLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // required
    
    func configureImageView() {
        imageView.layer.cornerRadius = 10
        imageView.clipToBounds = true
    }
    
    func configureTitleLabel() {
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        asdf
    }
}
