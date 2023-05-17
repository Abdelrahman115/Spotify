//
//  ArtistsTableViewCell.swift
//  Spotify
//
//  Created by Abdelrahman on 13/05/2023.
//

import UIKit
import SDWebImage

struct DefaultTableViewCellViewModel{
    let title:String
    let url:String
}

class DefaultTableViewCell: UITableViewCell {
    static let identifier = "DefaultTableViewCell"
    
    private let label:UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let cellImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(cellImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize:CGFloat = contentView.height - 10
        cellImageView.frame = CGRect(x: 10, y: 0, width: Int(imageSize), height: Int(imageSize))
        cellImageView.layer.cornerRadius = imageSize/2
        cellImageView.layer.masksToBounds = true
        label.frame = CGRect(x: cellImageView.right + 15, y: 0, width: contentView.width - cellImageView.right - 15, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        label.text = nil
    }
    
    func configure(viewModel:DefaultTableViewCellViewModel){
        label.text = viewModel.title
        cellImageView.sd_setImage(with: URL(string: viewModel.url ),placeholderImage: UIImage(systemName: "music.quarternote.3"))
    }
    
}
