//
//  FetchCategoryPlaylistViewModel.swift
//  Spotify
//
//  Created by Abdelrahman on 12/05/2023.
//



import Foundation
import UIKit

class FetchCaregoriePlaylist{
    
    
    /*private let playlist:itemOptions
    init(playlist:itemOptions){
        self.playlist = playlist
        //super.init(nibName: nil, bundle: nil)
    }*/
    var bindCategoriyPlaylistDetails:(() -> ()) = {}
    var categoryDetails:CategoryPlaylistResponse?{
        didSet{
            bindCategoriyPlaylistDetails()
        }
    }
    
    
    func fetchCategoriesData(id:String){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getCategoriesPlaylists(category: id){ result in
            
            switch result{
            case.success(let model):
                self.categoryDetails = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
