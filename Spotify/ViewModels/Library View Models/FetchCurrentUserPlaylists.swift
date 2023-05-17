//
//  FetchCurrentUserPlaylists.swift
//  Spotify
//
//  Created by Abdelrahman on 15/05/2023.
//

import Foundation
import UIKit

class FetchCureentUserPlaylist{
    
    
    /*private let playlist:itemOptions
    init(playlist:itemOptions){
        self.playlist = playlist
        //super.init(nibName: nil, bundle: nil)
    }*/
    var bindUserPlaylistResult:(() -> ()) = {}
    var currentUserPlaylists:playlist?{
        didSet{
            bindUserPlaylistResult()
        }
    }
    
    
    func fetchCurrentUserPlaylist(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getCurrentUserPlaylist { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.currentUserPlaylists = model
            case.failure(let error):
                print(error)
            }
        }
    }
}


