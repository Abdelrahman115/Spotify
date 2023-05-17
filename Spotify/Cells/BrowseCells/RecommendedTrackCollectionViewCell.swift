//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Abdelrahman on 04/05/2023.
//

import UIKit
import SDWebImage

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let trackImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .semibold)
        label.numberOfLines = 0

        return label
    }()
    
    private let artistNameLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13,weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(trackImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //let imageSize:CGFloat = contentView.height-10
        trackImageView.frame = CGRect(x: 5, y: 5, width: contentView.width, height: contentView.height - 100)
        
        trackNameLabel.frame = CGRect(x:5, y: trackImageView.bottom + 20, width: contentView.width, height: 30)
        artistNameLabel.frame = CGRect(x: 5, y: trackNameLabel.bottom, width: contentView.width, height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
       artistNameLabel.text = nil
        //numberOfTracksLabel.text = nil
        trackImageView.image = nil
    }
    
    func configureWithViewModel(viewModel:AudioTrack){
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.album.artists.first?.name
        //numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        trackImageView.sd_setImage(with: URL(string: viewModel.album.images?.first?.url ?? ""))
    }
    
    
    
    
    
}
