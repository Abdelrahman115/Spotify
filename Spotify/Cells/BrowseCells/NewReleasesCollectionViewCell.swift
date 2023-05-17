//
//  NewReleasesCollectionViewCell.swift
//  Spotify
//
//  Created by Abdelrahman on 04/05/2023.
//

import UIKit
import SDWebImage

/*
 struct NewReleasesCellViewModel{
     let name:String
     let asrtworkURL:URL?
     let numberOfTracks:Int
     let artistName:String
 }
 */

class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    
    private let albumCoverImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .bold)
        label.numberOfLines = 0

        return label
    }()
    
    private let numberOfTracksLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13,weight: .regular)
        label.numberOfLines = 0

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        artistNameLabel.sizeToFit()
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: contentView.width, height: contentView.height - 100)
        albumNameLabel.frame = CGRect(x:5, y: albumCoverImageView.bottom + 20, width: contentView.width, height: 30)
        artistNameLabel.frame = CGRect(x: 5, y: albumNameLabel.bottom , width: contentView.width, height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configureWithViewModel(viewModel:item){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artists[0].name
        //numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with:  URL(string: viewModel.images[0].url ?? ""))
    }
    
    
}
