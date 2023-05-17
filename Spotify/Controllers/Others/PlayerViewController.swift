//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit
import SDWebImage
import AVFoundation
import RealmSwift

class PlayerViewController: UIViewController {
    
    private let controlsView = PlayerControlView()
    private var player:AVPlayer?
    private var playerTracks:[AudioTrack] = []
    private var albumTracks:[AlbumDetaisls] = []
    private var favorites:[Favorites] = []
    var imageURL:String = ""
    var index:Int = 0

    let coverImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    init(playerTracks:[AudioTrack]?,albumTracks:[AlbumDetaisls]?){
        self.playerTracks = playerTracks ?? self.playerTracks
        self.albumTracks = albumTracks ?? self.albumTracks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureBarButtons()
        configure()
        playMusic(index: index)
        //RealmManager.shared.deleteAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        coverImageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10, y: coverImageView.bottom + 10, width: view.width-20, height: view.height - coverImageView.height-view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(coverImageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        if playerTracks.isEmpty{
            let id = albumTracks[index].id
            checkRealm(id: id)
        }else{
            let id = playerTracks[index].id
            checkRealm(id: id)
        }
        
    }
    
    
    private func checkRealm(id:String){
        favorites.removeAll()
        favorites.append(contentsOf: RealmManager.shared.getAllObjects(Favorites.self))
        
        for each in favorites{
            if id == each.id{
                controlsView.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                controlsView.likeButton.tintColor = .label
                controlsView.exist = true
                break
            }
        }
    }
    
    private func configure(){
        if playerTracks.isEmpty{
            coverImageView.sd_setImage(with: URL(string: imageURL))
            let songName = self.albumTracks[index].name
            let artistName = self.albumTracks[index].artists.first?.name ?? ""
            controlsView.configure(songName: songName, artistName: artistName)
        }else if albumTracks.isEmpty{
            let imageURL = self.playerTracks[index].album.images?.first?.url ?? ""
            let songName = self.playerTracks[index].name
            let artistName = self.playerTracks[index].album.artists.first?.name ?? ""
            coverImageView.sd_setImage(with: URL(string: imageURL))
            controlsView.configure(songName: songName, artistName: artistName)
        }
    }
    
    private func playMusic(index:Int){
        if albumTracks.isEmpty{
            self.index = index
            guard let url = URL(string: self.playerTracks[index].preview_url ?? "") else {return}
            player = AVPlayer(url: url)
            self.player?.play()
        }else if playerTracks.isEmpty{
            self.index = index
            guard let url = URL(string: self.albumTracks[index].preview_url ?? "") else {return}
            player = AVPlayer(url: url)
            self.player?.play()
        }
    }
    
    private func configureBarButtons(){
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTabClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTabAction))
    }
    
    @objc private func didTabClose(){
        dismiss(animated: true)
    }
    
    @objc private func didTabAction(){
        guard let url = URL(string: playerTracks[index].external_urls["spotify"] ?? "") else {
            return
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
}

// MARK: - player delegete

extension PlayerViewController:PlayerControlViewDelegate{
    func playerControlsViewDidTabLikeButton(_ playerControlView: PlayerControlView, exist: Bool) {
        var id:String = ""
        if playerTracks.isEmpty{
            id = albumTracks[index].id
        }else{
            id = playerTracks[index].id
        }
        if exist{
           
            APICaller.shared.unlikeTrack(id:id) { success in
                if success{
                    DispatchQueue.main.async {
                        RealmManager.shared.deleteDatafromFavorites(id: id)
                        HapticsManagr.shared.vibrate(for: .success)
                        print("object Deleted")
                    }
                }
            }
            
        }else{
            
            APICaller.shared.likeTrack(id:id) { success in
                if success{
                    DispatchQueue.main.async {
                        let obj = Favorites()
                        obj.id = id
                        RealmManager.shared.saveDataToFavorites(obj: obj)
                        HapticsManagr.shared.vibrate(for: .success)
                        print("object saved")
                    }
                }
            }
        }
    }
    

    
    func playerControlsView(_ playerControlsView: PlayerControlView, didSlideSlider value: Float) {
        player?.volume = value
    }
    
    func playerControlsViewDidTabPlayPauseButton(_ playerControlView: PlayerControlView) {
        guard let player = player else {return}
        if player.timeControlStatus == .playing{
            player.pause()
            controlsView.configurePlay()
            
        }else if player.timeControlStatus == .paused{
            player.play()
            controlsView.configurePause()
        }
    }
    
    func playerControlsViewDidTabNextButton(_ playerControlView: PlayerControlView) {
        if self.albumTracks.isEmpty{
            if index < playerTracks.count-1{
                index += 1
                playMusic(index: index)
                let id = playerTracks[index].id
                controlsView.exist = false
                controlsView.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                checkRealm(id: id)
                let imageURL = self.playerTracks[index].album.images?.first?.url ?? ""
                let songName = self.playerTracks[index].name
                let artistName = self.playerTracks[index].album.artists.first?.name ?? ""
                coverImageView.sd_setImage(with: URL(string: imageURL))
                controlsView.configure(songName: songName, artistName: artistName)
            }else{
                index = 0
                playMusic(index: index)
                let id = playerTracks[index].id
                
                controlsView.exist = false
                controlsView.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                checkRealm(id: id)
                //controlsView.didTapLikeButton()
                let imageURL = self.playerTracks[index].album.images?.first?.url ?? ""
                let songName = self.playerTracks[index].name
                let artistName = self.playerTracks[index].album.artists.first?.name ?? ""
                coverImageView.sd_setImage(with: URL(string: imageURL))
                controlsView.configure(songName: songName, artistName: artistName)
            }
            
            
            
        }else if self.playerTracks.isEmpty{
            if index < albumTracks.count-1{
                
                index += 1
                let id = albumTracks[index].id
                playMusic(index: index)
                controlsView.exist = false
                controlsView.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                checkRealm(id: id)
                let imageURL = self.imageURL
                let songName = self.albumTracks[index].name
                let artistName = self.albumTracks[index].artists.first?.name ?? ""
                coverImageView.sd_setImage(with: URL(string: imageURL))
                controlsView.configure(songName: songName, artistName: artistName)
            }else{
                index = 0
                let id = albumTracks[index].id
                //player?.pause()
                playMusic(index: index)
                controlsView.exist = false
                controlsView.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                checkRealm(id: id)
                let imageURL = self.imageURL
                let songName = self.albumTracks[index].name
                let artistName = self.albumTracks[index].artists.first?.name ?? ""
                coverImageView.sd_setImage(with: URL(string: imageURL))
                controlsView.configure(songName: songName, artistName: artistName)
            }
        }
    }
    
    func playerControlsViewDidTabBackButton(_ playerControlView: PlayerControlView) {
        if self.albumTracks.isEmpty{
            if index > 0{
                index -= 1
                playMusic(index: index)
                let id = playerTracks[index].id
                controlsView.exist = false
                controlsView.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                checkRealm(id: id)
                let imageURL = self.playerTracks[index].album.images?.first?.url ?? ""
                let songName = self.playerTracks[index].name
                let artistName = self.playerTracks[index].album.artists.first?.name ?? ""
                coverImageView.sd_setImage(with: URL(string: imageURL))
                controlsView.configure(songName: songName, artistName: artistName)
            }else{
                index = playerTracks.count - 1
                playMusic(index: index)
                let id = playerTracks[index].id
                
                controlsView.exist = false
                controlsView.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                checkRealm(id: id)
                //controlsView.didTapLikeButton()
                let imageURL = self.playerTracks[index].album.images?.first?.url ?? ""
                let songName = self.playerTracks[index].name
                let artistName = self.playerTracks[index].album.artists.first?.name ?? ""
                coverImageView.sd_setImage(with: URL(string: imageURL))
                controlsView.configure(songName: songName, artistName: artistName)
            }
            
            
            
        }else if self.playerTracks.isEmpty{
            if index > 0 {
                
                index -= 1
                let id = albumTracks[index].id
                playMusic(index: index)
                controlsView.exist = false
                controlsView.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                checkRealm(id: id)
                let imageURL = self.imageURL
                let songName = self.albumTracks[index].name
                let artistName = self.albumTracks[index].artists.first?.name ?? ""
                coverImageView.sd_setImage(with: URL(string: imageURL))
                controlsView.configure(songName: songName, artistName: artistName)
            }else{
                index = albumTracks.count - 1
                let id = albumTracks[index].id
                //player?.pause()
                playMusic(index: index)
                controlsView.exist = false
                controlsView.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                checkRealm(id: id)
                let imageURL = self.imageURL
                let songName = self.albumTracks[index].name
                let artistName = self.albumTracks[index].artists.first?.name ?? ""
                coverImageView.sd_setImage(with: URL(string: imageURL))
                controlsView.configure(songName: songName, artistName: artistName)
            }
        }
    }
    
    
}
