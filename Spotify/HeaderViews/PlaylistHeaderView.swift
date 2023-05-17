//
//  PlaylistHeaderView.swift
//  Spotify
//
//  Created by Abdelrahman on 08/05/2023.
//

import UIKit

protocol playlistPlayButtonDelegeta:AnyObject{
    func didTabPlayAll(_ header:PlaylistHeaderView)
    func didTapLikeButton(_ header:PlaylistHeaderView,exist:Bool)
}

class PlaylistHeaderView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderView"
    var exist = false
    
    weak var delegate:playlistPlayButtonDelegeta?
    
    let playlistImage:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    
    private let playlistButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    
    let likeButton:UIButton = {
        let button = UIButton()
        //button.backgroundColor = .systemGreen
        
        
        button.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    let playlistName:UILabel = {
      let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        
        //label.text = "Ahmed"
        return label
    }()
    
    let playlistOwner:UILabel = {
      let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        //label.text = "Mohamed"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addSubview(headerLbl)
        addSubview(playlistImage)
        addSubview(playlistButton)
        addSubview(likeButton)
        addSubview(playlistName)
        addSubview(playlistOwner)
        playlistButton.addTarget(self, action: #selector(didTabPlayAllButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //headerLbl.frame = CGRect(x: width / 3, y: self.height - 200, width: self.width, height: self.height)
        //headerLbl.center = CGPoint(x: 0, y: 0)
        playlistImage.frame = CGRect(x: 0, y: 0, width: width, height: height-60)
        playlistButton.frame = CGRect(x: width-60, y: height-55, width: 50, height: 50)
        //likeButton.frame = CGRect(x: width - 130, y: height-55, width: 50, height: 50)
        likeButton.frame = CGRect(x: 10, y: height-55, width: 50, height: 50)
        playlistName.frame = CGRect(x: likeButton.right-10, y: height-58, width: width-playlistButton.width-likeButton.width-10, height: 30)
        playlistOwner.frame = CGRect(x: likeButton.right-10, y: playlistName.bottom, width: width-playlistButton.width-likeButton.width-10, height: 30)
    }
    
    @objc private func didTabPlayAllButton(){
        delegate?.didTabPlayAll(self)
    }
    
    @objc private func didTapLikeButton(){
        if exist{
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
       }else{
           likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
           likeButton.tintColor = .systemGreen
       }
        delegate?.didTapLikeButton(self,exist:exist)
        exist = !exist
    }
    
    func configure(playlistName:String,ownerName:String){
        self.playlistName.text = playlistName
        self.playlistOwner.text = ownerName
    }
    
}
