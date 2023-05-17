//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 07/05/2023.
//

import UIKit
import RealmSwift

class AlbumViewController: UIViewController {

    var viewModel:FetchAlbumDetails!
    private var tracks:[AlbumDetaisls] = []
    private let album:item
    private var collectionView:UICollectionView?
    //private var viewModels = [RecommendedTrackCellViewModel]()
    init(album:item){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func setupUI(){
        title = album.name
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTabShareButton))
    }
    
    @objc private func didTabShareButton(){
        guard let url = URL(string: album.external_urls["spotify"] ?? "") else {
            return
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
    private func fetchData(){
        viewModel = FetchAlbumDetails(album: album)
        viewModel.fetchData()
        viewModel.bindAlbumDetails = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let tracks = self.viewModel.albumDetails?.tracks.items else {return}
                self.tracks = tracks
                /*self.viewModels = (self.viewModel.albumDetails?.tracks.items.compactMap({
                    RecommendedTrackCellViewModel(name:$0.name , artistName: $0.artists.first?.name ?? "-", artworkURL: URL(string: self.viewModel.albumDetails?.images.first?.url ?? ""))
                }))!*/
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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView?.register(PlaylistHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderView.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {return}
        view.addSubview(collectionView)
    }
}


// MARK: - Collection View Extensions
extension AlbumViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tracks.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
        
        //guard let model = self.viewModel.albumDetails else {return}
        
        cell.configureAlbums(viewModels: tracks,x: indexPath.row,model: viewModel.albumDetails!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        let vc = PlayerViewController(playerTracks: nil, albumTracks: self.tracks)
        vc.title = track.name
        vc.imageURL = album.images.first?.url ?? ""
        vc.index = indexPath.row
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        
        let albumHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderView.identifier, for: indexPath) as! PlaylistHeaderView
        
        for item in try! Realm().objects(Favorites.self).filter("id == %@",album.id){
            if album.id == item.id{
                albumHeader.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                albumHeader.likeButton.tintColor = .systemGreen
                albumHeader.exist = true
                //exist = true
            }
        }
        
        albumHeader.playlistImage.sd_setImage(with: URL(string: album.images[0].url ?? ""))
        albumHeader.configure(playlistName: album.name, ownerName: album.artists.first?.name ?? "")
        albumHeader.delegate = self
        return albumHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height/3)
    }
    
    
}

// MARK: - Header Delegate Extensions

extension AlbumViewController:playlistPlayButtonDelegeta{
    func didTapLikeButton(_ header: PlaylistHeaderView, exist: Bool) {
        if exist{
           
            APICaller.shared.unfollowAlbum(album: album) { success in
                if success{
                    DispatchQueue.main.async {
                        RealmManager.shared.deleteDatafromFavorites(id: self.album.id)
                        HapticsManagr.shared.vibrate(for: .success)
                        print("object Deleted")
                    }
                }
            }
            
        }else{
            
            APICaller.shared.likeAlbum(album: album) { success in
                if success{
                    DispatchQueue.main.async {
                        let obj = Favorites()
                        obj.id = self.album.id
                        RealmManager.shared.saveDataToFavorites(obj: obj)
                        HapticsManagr.shared.vibrate(for: .success)
                        print("object saved")
                    }
                }
            }
        }
    }
    
    func didTabPlayAll(_ header: PlaylistHeaderView) {
        //PlayBackPresenter.shared.startAlbumPlayback(from: self, tracks: tracks)
        let vc = PlayerViewController(playerTracks: nil, albumTracks: self.tracks)
        vc.imageURL = album.images.first?.url ?? ""
        vc.index = Int.random(in: 0..<self.tracks.count)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
