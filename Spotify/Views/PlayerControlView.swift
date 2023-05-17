//
//  PlayerControlView.swift
//  Spotify
//
//  Created by Abdelrahman on 13/05/2023.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerControlViewDelegate:AnyObject{
    func playerControlsViewDidTabPlayPauseButton(_ playerControlView:PlayerControlView)
    func playerControlsViewDidTabNextButton(_ playerControlView:PlayerControlView)
    func playerControlsViewDidTabBackButton(_ playerControlView:PlayerControlView)
    func playerControlsView(_ playerControlsView:PlayerControlView, didSlideSlider value:Float)
    func playerControlsViewDidTabLikeButton(_ playerControlView:PlayerControlView,exist:Bool)
}

final class PlayerControlView:UIView{
    
    weak var delegate:PlayerControlViewDelegate?
    
    var exist = false
    
    private let volumeSlider:UISlider = {
       let slider = UISlider()
        slider.value = 0.0
        slider.tintColor = .systemGreen
        return slider
    }()
    
    private var nameLabel:UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        //label.text = "MySong"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private var subtitleLabel:UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        //label.text = "AmrDiab"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40,weight: .bold))
        button.setImage(image, for: .normal)
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
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom, width: width, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom + 20, width: width-20, height: 44)
        
        let buttonSize:CGFloat = 60
        playPauseButton.frame = CGRect(x: (width-buttonSize)/3, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left-30-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x: playPauseButton.right+30, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        likeButton.frame = CGRect(x: nextButton.right + 50, y: playPauseButton.top+5, width: 50, height: 50)
    }
    
    private func setupUI(){
        backgroundColor = .systemBackground
        addSubview(volumeSlider)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        addSubview(likeButton)
        backButton.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTabNextButton), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTabPlayPauseButton), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    
    func configure(songName:String,artistName:String){
        self.nameLabel.text = songName
        self.subtitleLabel.text = artistName
    }
    
    func configurePlay(){
            let image = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40,weight: .bold))
            playPauseButton.setImage(image, for: .normal)
    }
    
    func configurePause(){
        let image = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40,weight: .bold))
        playPauseButton.setImage(image, for: .normal)
    }
    
    @objc private func didTabBackButton(){
        delegate?.playerControlsViewDidTabBackButton(self)
    }
    @objc private func didTabNextButton(){
        delegate?.playerControlsViewDidTabNextButton(self)
    }
    @objc private func didTabPlayPauseButton(){
        delegate?.playerControlsViewDidTabPlayPauseButton(self)
    }
    
    @objc func didSlideSlider(_ slider:UISlider){
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc func didTapLikeButton(){
        if exist{
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
            
           //sender.setImage(UIImage(systemName: "star"), for: .normal)
           
       }else{
           //sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
           likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
           likeButton.tintColor = .label
           
       }
        delegate?.playerControlsViewDidTabLikeButton(self,exist: exist)
        exist = !exist
    }
}
