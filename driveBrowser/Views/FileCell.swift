//
//  FileCell.swift
//  Pods
//
//  Created by Ренат Рахматуллин on 26.04.2021.
//

import UIKit
import GoogleAPIClientForREST
import SDWebImage

class FileCell: UITableViewCell {
    static let identifier = "FileCell"
    
    var fileImageView = UIImageView()
    var fileNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(fileImageView)
        addSubview(fileNameLabel)
        
        configureImageView()
        configureTitleLabel()
        
        setImageViewConstraints()
        setNameLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureImageView() {
        fileImageView.layer.cornerRadius = 10
        fileImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        fileNameLabel.numberOfLines = 0
        fileNameLabel.adjustsFontSizeToFitWidth = true
        
        fileNameLabel.textColor = .black
        fileNameLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    func setImageViewConstraints() {
        fileImageView.translatesAutoresizingMaskIntoConstraints = false
        fileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        fileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        fileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        fileImageView.widthAnchor.constraint(equalTo: fileImageView.heightAnchor).isActive = true
    }
    
    func setNameLabelConstraints() {
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fileNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        fileNameLabel.leadingAnchor.constraint(equalTo: fileImageView.trailingAnchor, constant: 10).isActive = true
        fileNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        fileNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    func setData(data: GTLRDrive_File) {
        var fileSize = ""
        var dateStr = ""
        if let size = data.size as? Int {
            if size > 1073741824 {
                fileSize = String.localizedStringWithFormat("%.1fGB", Double(size / 1073741824))
            } else if size > 1048576 {
                fileSize = String.localizedStringWithFormat("%.1fMB", Double(size / 1048576))
            } else {
                fileSize = String.localizedStringWithFormat("%.1fKB", Double(size / 1024))
            }
        }
        if let date = data.modifiedTime?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateStr = data.isFolder() ? "\(formatter.string(from: date))" : "\(fileSize) - \(formatter.string(from: date))"
        }
        
        setCell(thumbnail: data.thumbnailLink, image: data.isFolder() ? "folderIcon" : "fileIcon", name: data.name!, time: data.isFolder() ? "Folder" : dateStr)
    }
    
    private func setCell(thumbnail: String?, image: String, name: String, time: String) {
        fileImageView.sd_setImage(with: URL(string: thumbnail ?? ""),
                                  placeholderImage: UIImage(named: image))
        
        let firstFont = UIFont.systemFont(ofSize: 17)
        let secondFont = UIFont.systemFont(ofSize: 13)
        let firstAttributes: [NSAttributedString.Key: Any] = [.font: firstFont,
                                                              .foregroundColor: UIColor.black]
        let secondAttributes: [NSAttributedString.Key: Any] = [.font: secondFont,
                                                                .foregroundColor: UIColor.gray]

        let firstString = NSMutableAttributedString(string: name + "\n", attributes: firstAttributes)
        let secondString = NSAttributedString(string: time, attributes: secondAttributes)

        firstString.append(secondString)
        
        fileNameLabel.attributedText = firstString

    }
}
