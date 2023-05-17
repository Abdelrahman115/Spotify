//
//  FetchPlaylistDetailsViewModel.swift
//  Spotify
//
//  Created by Abdelrahman on 07/05/2023.
//

import Foundation

import UIKit

class FetchPlaylistDetails{
    
    
    private let playlist:itemOptions
    init(playlist:itemOptions){
        self.playlist = playlist
        //super.init(nibName: nil, bundle: nil)
    }
    var bindPlaylistDetails:(() -> ()) = {}
    var playlistDetails:PlaylistDetailsResponse?{
        didSet{
            bindPlaylistDetails()
        }
    }
    
    
    func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getPlaylistDetails(for: playlist) { result in
            switch result{
            case.success(let model):
                self.playlistDetails = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
       
       
        
        /*group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else {
                fatalError("Models are nil")
            }
            
            configureModels(newAlbums: newAlbums, track: tracks, playlist: playlists,collectionView: collectionView)
        }*/
    }
}

