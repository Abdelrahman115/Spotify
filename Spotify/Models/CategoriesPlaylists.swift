//
//  CategoriesPlaylists.swift
//  Spotify
//
//  Created by Abdelrahman on 12/05/2023.
//

import Foundation


//CategoryPlaylistResponse
struct CategoryPlaylistResponse:Codable{
    let playlists:playlistCategory
}


struct playlistCategory:Codable{
    let href:String
    let items:[itemOptions]
}
