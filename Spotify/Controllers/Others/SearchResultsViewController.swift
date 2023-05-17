//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit
import SafariServices


protocol SearchResultsViewControllerDelegate:AnyObject{
    func showResult(_ controller:UIViewController)
}

class SearchResultsViewController: UIViewController {

    
    private var artists:[Artist] = []
    private var albums:[item] = []
    private var playlists:[itemOptions] = []
    private var tracks:[AudioTrack] = []
    
    weak var delegate:SearchResultsViewControllerDelegate?
    
    private var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.identifier)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupUI(){
        view.backgroundColor = .clear
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    func update(with results:SearchResultResponse){
        artists = results.artists.items
        albums = results.albums.items
        playlists = results.playlists.items
        tracks = results.tracks.items
        
        if artists.isEmpty == false || albums.isEmpty == false || playlists.isEmpty == false || tracks.isEmpty == false{
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
}



// MARK: - Table View Extensions
extension SearchResultsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return artists.count
        case 1:
            return albums.count
        case 2:
            return playlists.count
        case 3:
            return tracks.count
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as! DefaultTableViewCell
            let model = DefaultTableViewCellViewModel(title: artists[indexPath.row].name, url: artists[indexPath.row].images?.first?.url ?? "")
            cell.configure(viewModel: model)
            return cell
        case 1:
            let album = albums[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier, for: indexPath) as! SubtitleTableViewCell
            let model = SubtitleTableViewCellViewModel(title: album.name, url: album.images.first?.url ?? "", artist: album.artists.first?.name ?? "")
            cell.configure(viewModel: model)
            return cell
        case 2:
            let playlist = playlists[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier, for: indexPath) as! SubtitleTableViewCell
            let model = SubtitleTableViewCellViewModel(title: playlist.name, url: playlist.images.first?.url ?? "", artist: playlist.owner.display_name )
            cell.configure(viewModel: model)
            return cell
        case 3:
            let track = tracks[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier, for: indexPath) as! SubtitleTableViewCell
            let model = SubtitleTableViewCellViewModel(title: track.name, url: track.album.images?.first?.url ?? "", artist: track.album.artists.first?.name ?? "")
            cell.configure(viewModel: model)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = ""
            return cell
        }
        //return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Artist"
        case 1:
            return "Albums"
        case 2:
            return "Playlists"
        case 3:
            return "Tracks"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section{
        case 0:
            let artist = artists[indexPath.row]
            guard let url =  URL(string: artist.external_urls["spotify"] ?? "") else {return}
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            //print(artist.external_urls)
        case 1:
            let albumModel = albums[indexPath.row]
            let vc = AlbumViewController(album: albumModel)
            delegate?.showResult(vc)
        case 2:
            let playlistModel = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlistModel)
            delegate?.showResult(vc)
        case 3:
            let track = tracks[indexPath.row]
            
            let vc = PlayerViewController(playerTracks: self.tracks, albumTracks: nil)
            vc.title = track.name
            
            vc.index = indexPath.row
            delegate?.showResult(vc)
        default:
            print("default")
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}


