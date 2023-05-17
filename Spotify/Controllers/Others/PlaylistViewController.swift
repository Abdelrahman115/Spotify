//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit
import SDWebImage
import AVFoundation
import RealmSwift

class PlaylistViewController: UIViewController {
    
    public var isOwner = false
    
    var viewModel:FetchPlaylistDetails!
    private var tracks:[AudioTrack] = []
    var player:AVPlayer?
    //var exist = false
    
    
    private let playlist:itemOptions
    private var collectionView:UICollectionView?
    init(playlist:itemOptions){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //private var viewModels = [RecommendedTrackCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCollectionView()
        fetchData()
        addLongTapGeasture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func setupUI(){
        title = playlist.name
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTabShareButton))
        
        
    }
    
    private func addLongTapGeasture(){
        let geasture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView?.isUserInteractionEnabled = true
        collectionView?.addGestureRecognizer(geasture)
    }
    
    
    @objc private func didTabShareButton(){
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
    private func fetchData(){
        viewModel = FetchPlaylistDetails(playlist: playlist)
        viewModel.fetchData()
        viewModel.bindPlaylistDetails = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let tracks = self.viewModel.playlistDetails?.tracks.items else {return}
                
                for each in tracks{
                    self.tracks.append(each.track)
                    //vc.playerTracks.append(each.track)
                }
                //let vc = PlayerViewController(playerTracks: self.tracks)
                self.collectionView?.reloadData()
            }
        }
    }
    
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        let size = view.width
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        layout.itemSize = CGSize(width: size, height: size/6)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView?.backgroundColor = .label
        collectionView?.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView?.register(PlaylistHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderView.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {return}
        view.addSubview(collectionView)
    }
    
    
    @objc private func didLongPress(_ geasture:UILongPressGestureRecognizer){
        guard geasture.state == .began else {return}
        let touchPoint = geasture.location(in:collectionView)
        guard let indexPath = collectionView?.indexPathForItem(at: touchPoint) else {return}
        
        
            let track = tracks[indexPath.row]
            
        
        
        if isOwner{
            let actionSheet = UIAlertController(title: "Remove", message: "Do you want to remove this track from your playlist?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { [weak self] _ in
                guard let self = self else{return}
                APICaller.shared.removeTrackFromPlaylist(track: track, playlist: self.playlist) { success in
                    if success{
                        DispatchQueue.main.async {
                            self.tracks.remove(at: indexPath.row)
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
            present(actionSheet,animated: true)
        }else{
            let actionSheet = UIAlertController(title: "Add to your playlist", message: "Do you want to add this track to your playlist?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default,handler: { [weak self] _ in
                DispatchQueue.main.async {
                    let vc = LibraryPlaylistViewController()
                    vc.selectionHandler = { playlist in
                        APICaller.shared.addTrackToPlaylist(track: track, playlist: playlist) { _ in
                        }
                    }
                    vc.title = "Select Playlist"
                    self?.present(UINavigationController(rootViewController: vc),animated: true,completion: nil)
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
            present(actionSheet,animated: true)
        }
    }
}


// MARK: - Collection View Extensions
extension PlaylistViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tracks.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
        //let viewModel = viewModels[indexPath.row]
        cell.configure(viewModels: tracks,x: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        let vc = PlayerViewController(playerTracks: self.tracks,albumTracks: nil)
        vc.title = track.name
        vc.index = indexPath.row
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        /*present(UINavigationController(rootViewController: vc),animated: true) {[weak self] in
            self?.player?.play()
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        
        let playlistHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderView.identifier, for: indexPath) as! PlaylistHeaderView
        
        for item in try! Realm().objects(Favorites.self).filter("id == %@",playlist.id){
            if playlist.id == item.id{
                playlistHeader.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                playlistHeader.likeButton.tintColor = .systemGreen
                playlistHeader.exist = true
                //exist = true
            }
        }
        playlistHeader.playlistImage.sd_setImage(with: URL(string: playlist.images.first?.url ?? "" ),placeholderImage: UIImage(systemName: "music.quarternote.3"))
        playlistHeader.configure(playlistName: playlist.name, ownerName: playlist.owner.display_name)
        playlistHeader.delegate = self
        return playlistHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height/3)
    }
    
    
    
    
   
}


// MARK: - Header Delegate Extensions

extension PlaylistViewController:playlistPlayButtonDelegeta{
    func didTapLikeButton(_ header: PlaylistHeaderView, exist: Bool) {
        if exist{
           print("object Deleted")
            APICaller.shared.unfollowPlaylist(playlist: playlist) { success in
                if success{
                    DispatchQueue.main.async {
                        RealmManager.shared.deleteDatafromFavorites(id: self.playlist.id)
                        HapticsManagr.shared.vibrate(for: .success)
                    }
                }
            }
            
        }else{
            print("object saved")
            APICaller.shared.likePlaylist(playlist: playlist) { success in
                if success{
                    DispatchQueue.main.async {
                        let obj = Favorites()
                        obj.id = self.playlist.id
                        RealmManager.shared.saveDataToFavorites(obj: obj)
                        HapticsManagr.shared.vibrate(for: .success)
                    }
                }
            }
        }
    }
    
    func didTabPlayAll(_ header: PlaylistHeaderView) {
        let vc = PlayerViewController(playerTracks: self.tracks,albumTracks: nil)
        vc.index = Int.random(in: 0..<self.tracks.count)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
