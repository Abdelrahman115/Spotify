//
//  AlbumsTableViewCell.swift
//  Spotify
//
//  Created by Abdelrahman on 13/05/2023.
//

import UIKit
import SDWebImage

struct SubtitleTableViewCellViewModel{
    let title:String
    let url:String
    let artist:String
}

class SubtitleTableViewCell: UITableViewCell {
    static let identifier = "SubtitleTableViewCell"
    
    private let label:UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let label2:UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13, weight: .regular)
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
        contentView.addSubview(label2)
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
        cellImageView.frame = CGRect(x: 10, y: 5, width: Int(imageSize), height: Int(imageSize))
        cellImageView.layer.cornerRadius = imageSize/2
        cellImageView.layer.masksToBounds = true
        label.frame = CGRect(x: cellImageView.right + 15, y: 20 - 12, width: contentView.width - cellImageView.right - 15, height: contentView.height/2)
        label2.frame = CGRect(x: cellImageView.right + 15, y: label.bottom - 12, width: contentView.width - cellImageView.right - 15, height: contentView.height/2)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        label.text = nil
        label2.text = nil
    }
    
    func configure(viewModel:SubtitleTableViewCellViewModel){
        label.text = viewModel.title
        label2.text = viewModel.artist
        cellImageView.sd_setImage(with: URL(string: viewModel.url ),placeholderImage: UIImage(systemName: "music.quarternote.3"))
    }
    
}
