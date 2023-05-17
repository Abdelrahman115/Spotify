//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Abdelrahman on 04/05/2023.
//

import UIKit
import SDWebImage

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14,weight: .semibold)
        label.numberOfLines = 0

        return label
    }()
    
    private let playlistOwnerLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(playlistImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(playlistOwnerLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistImageView.frame = CGRect(x: 5, y: 5, width: contentView.width, height: contentView.height - 100)
        
        playlistNameLabel.frame = CGRect(x:5, y: playlistImageView.bottom, width: contentView.width, height: 100)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
       playlistOwnerLabel.text = nil
        //numberOfTracksLabel.text = nil
        playlistImageView.image = nil
    }
    
    func configureWithViewModel(viewModel:itemOptions){
        playlistNameLabel.text = viewModel.name
        //playlistOwnerLabel.text = viewModel.creatorName
        //numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        playlistImageView.sd_setImage(with: URL(string: viewModel.images.first?.url ?? ""))
    }
    
    func configure1(viewModels:[FeaturedPlaylistCellViewModel],Index:Int){
        playlistNameLabel.text = viewModels[Index].name
        playlistImageView.sd_setImage(with: viewModels[Index].artWorkURL)
        playlistOwnerLabel.text = viewModels[Index].creatorName
    }
    
    
}

    
    
    

