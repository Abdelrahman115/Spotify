//
//  FetchAlbumDetailsViewModel.swift
//  Spotify
//
//  Created by Abdelrahman on 07/05/2023.
//

import Foundation
import UIKit

class FetchAlbumDetails{
    
    
    private let album:item
    init(album:item){
        self.album = album
        //super.init(nibName: nil, bundle: nil)
    }
    var bindAlbumDetails:(() -> ()) = {}
    var albumDetails:AlbumDetailsResponse?{
        didSet{
            bindAlbumDetails()
        }
    }
    
    
    func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getAlbumDetails(for: album) { result in
            switch result{
            case.success(let model):
                self.albumDetails = model
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
