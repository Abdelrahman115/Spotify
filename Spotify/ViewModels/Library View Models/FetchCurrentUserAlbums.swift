//
//  FetchCurrentUserAlbums.swift
//  Spotify
//
//  Created by Abdelrahman on 16/05/2023.
//

import Foundation


class FetchCureentUserAlbums{
    
    
    /*private let playlist:itemOptions
    init(playlist:itemOptions){
        self.playlist = playlist
        //super.init(nibName: nil, bundle: nil)
    }*/
    var bindUserAlbumstResult:(() -> ()) = {}
    var currentUserAlbums:CurrentUserAlbumsResponse?{
        didSet{
            bindUserAlbumstResult()
        }
    }
    
    
    func fetchCurrentUserAlbums(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getCurrentUserAlbums { result in
            switch result{
            case.success(let model):
                self.currentUserAlbums = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


