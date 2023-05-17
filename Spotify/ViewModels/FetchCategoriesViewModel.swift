//
//  FetchCategoriesViewModel.swift
//  Spotify
//
//  Created by Abdelrahman on 12/05/2023.
//

import Foundation


import Foundation
import UIKit

class FetchCaregories{
    
    
    //private let album:item
    /*init(album:item){
        self.album = album
        //super.init(nibName: nil, bundle: nil)
    }*/
    var bindCategoriesDetails:(() -> ()) = {}
    var categoryDetails:Categories?{
        didSet{
            bindCategoriesDetails()
        }
    }
    
    
    func fetchCategoriesData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getCategories { result in
            switch result{
            case.success(let model):
                
                
                self.categoryDetails = model
                
              
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
