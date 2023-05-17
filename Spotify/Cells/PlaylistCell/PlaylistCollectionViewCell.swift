//
//  PlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Abdelrahman on 08/05/2023.
//

import UIKit
import SDWebImage

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaylistCollectionViewCell"
    
    private var trackImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var trackNameLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .bold)
        label.numberOfLines = 0

        return label
    }()
    
    private var artistNameLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13,weight: .regular)
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
        let imageSize:CGFloat = contentView.height-10
        
        
        
        trackImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
       
        
            trackNameLabel.frame = CGRect(x:trackImageView.right + 15, y: 5, width: contentView.width, height: imageSize / 2)
        
            artistNameLabel.frame = CGRect(x: trackImageView.right + 15, y: trackNameLabel.bottom, width: contentView.width, height: imageSize/2)
        
        //numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right+10, y: albumCoverImageView.bottom-35, width: numberOfTracksLabel.width+10, height: 40)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
       trackImageView.image = nil
    }
    
    func configure(viewModels:[AudioTrack],x:Int){
        trackNameLabel.text = viewModels[x].name
        artistNameLabel.text = viewModels[x].album.artists.first?.name
        trackImageView.sd_setImage(with: URL(string: viewModels[x].album.images?.first?.url ?? ""))
    }
    
    func configureAlbums(viewModels:[AlbumDetaisls],x:Int,model:AlbumDetailsResponse){
        trackNameLabel.text = viewModels[x].name
        artistNameLabel.text = viewModels[x].artists.first?.name
        trackImageView.sd_setImage(with: URL(string: model.images.first?.url ?? ""))
    }
    
   
    
}
