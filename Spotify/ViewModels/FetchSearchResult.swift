//
//  FetchSearchResult.swift
//  Spotify
//
//  Created by Abdelrahman on 13/05/2023.
//

import Foundation
import UIKit

class FetchSearchResult{
    
    
    /*private let playlist:itemOptions
    init(playlist:itemOptions){
        self.playlist = playlist
        //super.init(nibName: nil, bundle: nil)
    }*/
    var bindSearchResult:(() -> ()) = {}
    var searchResult:SearchResultResponse?{
        didSet{
            bindSearchResult()
        }
    }
    
    
    func fetchSearchResult(query:String){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.search(with: query) { result in
            switch result{
            case.success(let model):
                self.searchResult = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

