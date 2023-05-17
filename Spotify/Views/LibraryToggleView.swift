//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Abdelrahman on 15/05/2023.
//

import UIKit

protocol LibraryToggleViewDelegate:AnyObject{
    func didTapAlbumsButton(_ toggleView:LibraryToggleView)
    func didTapPlaylistButton(_ toggleView:LibraryToggleView)
    func didTapTracksButton(_ toggleView:LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State{
        case playlist
        case album
        case track
    }
    
    var state:State = .playlist
    weak var delegate:LibraryToggleViewDelegate?
    
    private let indicatorView:UIView = {
       let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let playlistButton:UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton:UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let tracksButton:UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Tracks", for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(playlistButton)
        addSubview(albumsButton)
        addSubview(tracksButton)
        addSubview(indicatorView)
        playlistButton.addTarget(self, action: #selector(didTapPlaylistButton), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbumsButton), for: .touchUpInside)
        tracksButton.addTarget(self, action: #selector(didTapTracks), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumsButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40)
        tracksButton.frame = CGRect(x: albumsButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
    }
    
    private func layoutIndicator(){
        switch state{
        case.playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistButton.bottom, width: 100, height: 3)
        case.album:
            indicatorView.frame = CGRect(x: 100, y: albumsButton.bottom, width: 100, height: 3)
        case.track:
            indicatorView.frame = CGRect(x: 200, y: tracksButton.bottom, width: 100, height: 3)
        }
    }
    
    func updateForState(state:State){
        self.state = state
        UIView.animate(withDuration: 0.0) {
            self.layoutIndicator()
        }
    }
    
    @objc private func didTapPlaylistButton(){
        state = .playlist
        self.updateForState(state: state)
        delegate?.didTapPlaylistButton(self)
    }
    
    @objc private func didTapAlbumsButton(){
        state = .album
        self.updateForState(state: state)
        delegate?.didTapAlbumsButton(self)
    }
    
    
    @objc private func didTapTracks(){
        state = .track
        self.updateForState(state: state)
        delegate?.didTapTracksButton(self)
    }
    
    
}
