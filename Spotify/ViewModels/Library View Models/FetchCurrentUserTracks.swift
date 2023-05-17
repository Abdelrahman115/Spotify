//
//  FetchCurrentUserTracks.swift
//  Spotify
//
//  Created by Abdelrahman on 17/05/2023.
//

import Foundation

class FetchCureentUserTracks{
    
    
    /*private let playlist:itemOptions
    init(playlist:itemOptions){
        self.playlist = playlist
        //super.init(nibName: nil, bundle: nil)
    }*/
    var bindUserTracksResult:(() -> ()) = {}
    var currentUserTracks:CureentUserTracksResponse?{
        didSet{
            bindUserTracksResult()
        }
    }
    
    
    func fetchCurrentUserTracks(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getCurrentUserTracks { result in
            switch result{
            case.success(let model):
                self.currentUserTracks = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


