//
//  HomeViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit
import AVFoundation

enum BrowseSectionType{
    case newReleases(viewModels:[NewReleasesCellViewModel])
    case featuredPlaylist(viewModels:[FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels:[RecommendedTrackCellViewModel])
}

class HomeViewController: UIViewController {
    var viewModel:FetchHomeData!
    
    var player:AVPlayer?
    
    
    //Models for display
    private var artists:[Artist] = []
    private var albums:[item] = []
    private var playlists:[itemOptions] = []
    private var tracks:[AudioTrack] = []
    
    private let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        //imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let greatingLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        //label.text = "Good After Noon"
        return label
    }()
    
    private let settingsButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "gear",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
   
    
    private var collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return CompositionalLayout.createSectionLayout(Section: sectionIndex)
    })
    
    private let spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        configureCollectionView()
        addLongTapGeasture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBar = TabBarViewController()
        imageView.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: 50, height: 50)
        greatingLabel.frame = CGRect(x: imageView.right + 10, y: view.safeAreaInsets.top, width: view.width - imageView.width, height: 50)
        settingsButton.frame = CGRect(x: view.width-40, y:  view.safeAreaInsets.top+10, width: 30, height: 30)
        collectionView.frame  = CGRect(x: 0, y: imageView.bottom, width: view.bounds.width, height:view.bounds.height-imageView.height-tabBar.tabBar.height-view.safeAreaInsets.bottom)
    }
    
    
    private func setupUI(){
        //title = "Browse"
        view.addSubview(collectionView)
        view.addSubview(imageView)
        view.addSubview(greatingLabel)
        view.addSubview(settingsButton)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.backgroundColor = .systemBackground
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTabSettings))
        settingsButton.addTarget(self, action: #selector(didTabSettings), for: .touchUpInside)
        
        let date = Date()
        let calender = Calendar.current
        let hour = calender.component(.hour, from: date)
        switch hour{
        case 0 ... 11:
            greatingLabel.text = "Good Morning"
        case 12 ... 18:
            greatingLabel.text = "Good Afternoon"
        case 19 ... 23:
            greatingLabel.text = "Good Evening"
        default:
            break
        }
    }
    
    private func fetchData(){
        viewModel = FetchHomeData()
        viewModel.fetchData(collectionView: collectionView)
        viewModel.fetchProfile()
        viewModel.bindNewReleasesToHomeView = {[weak self] in
            DispatchQueue.main.async {
                guard let album = self?.viewModel.newReleases?.albums.items else {return}
                self?.albums = album
                self?.collectionView.reloadData()
            }
        }
        viewModel.bindPlaylistsToHomeView = {[weak self] in
            DispatchQueue.main.async {
                guard let playlist = self?.viewModel.featuredPlaylist?.playlists.items else {return}
                self?.playlists = playlist
                self?.collectionView.reloadData()
            }
        }
        viewModel.bindRecommendationsToHomeView = {[weak self] in
            DispatchQueue.main.async {
                guard let track = self?.viewModel.recommendations?.tracks else {return}
                self?.tracks = track
                self?.collectionView.reloadData()
            }
        }
        viewModel.bindProfileToHomeView = {[weak self] in
            DispatchQueue.main.async {
                guard let profile = self?.viewModel.profile else {return}
                self?.setUserPicture(model: profile)
                UserDefaults.standard.set(profile.id, forKey: "userID")
                //_ = UserDefaults.standard.string(forKey: "userID") ?? ""
                
            }
        }
    }
    
    private func setUserPicture(model:UserProfile){
        let imageURL = model.images?.first?.url ?? ""
        self.imageView.sd_setImage(with: URL(string: imageURL))
    }
    
    private func configureCollectionView(){
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.backgroundColor = .systemBackground
    }
    
    private func addLongTapGeasture(){
        let geasture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(geasture)
    }

    
    @objc private func didTabSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didLongPress(_ geasture:UILongPressGestureRecognizer){
        guard geasture.state == .began else {return}
        let touchPoint = geasture.location(in:collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
        indexPath.section == 2 else {return}
        
        let model = tracks[indexPath.row]
        let actionSheet = UIAlertController(title: model.name, message: "Would You like to add this to a playlist?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default,handler: { [weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistViewController()
                vc.selectionHandler = { playlist in
                    APICaller.shared.addTrackToPlaylist(track: model, playlist: playlist) { _ in
                    }
                }
                vc.title = "Select Playlist"
                self?.present(UINavigationController(rootViewController: vc),animated: true,completion: nil)
            }
        }))
        present(actionSheet,animated: true)
    }
   
}


// MARK: - Extensions


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return albums.count
        case 1:
            return playlists.count
        case 2:
            return tracks.count
        default:
            return 5
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = indexPath.section
        switch type{
        case 0:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as! NewReleasesCollectionViewCell
          
            let viewModel = albums[indexPath.row]
            cell.configureWithViewModel(viewModel: viewModel)
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturedPlaylistCollectionViewCell
            
            let viewModel = playlists[indexPath.row]
            cell.configureWithViewModel(viewModel: viewModel)
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as! RecommendedTrackCollectionViewCell
            
            let viewModel = tracks[indexPath.row]
            cell.configureWithViewModel(viewModel: viewModel)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as! RecommendedTrackCollectionViewCell
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManagr.shared.vibrateForSelection()
        switch indexPath.section{
        case 0:
            let album = albums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        
        case 2:
            let track = tracks[indexPath.row]
         
            let vc = PlayerViewController(playerTracks: self.tracks,albumTracks: nil)
            vc.title = track.name
            vc.index = indexPath.row
            vc.hidesBottomBarWhenPushed = true
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            /*present(UINavigationController(rootViewController: vc),animated: true) {[weak self] in
                self?.player?.play()
            }*/
        
        default:
            print("")
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else{
            return UICollectionReusableView()
        }
        switch indexPath.section{
        case 0:
            view.headerLbl.text = "New Releases"
       
        case 1:
            view.headerLbl.text = "Featured Playlists"
        
        case 2:
            view.headerLbl.text = "Recommended Tracks"
        default:
            view.headerLbl.text = ""
        }
        return view
    }
    
    
}
