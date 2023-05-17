//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by Abdelrahman on 13/05/2023.
//

import Foundation

struct SearchResultResponse:Codable{
    let albums:albumSearch
    let artists:artistSearch
    let playlists:playlistSearch
    let tracks:tracksSearch
}

struct albumSearch:Codable{
    let href:String
    let items:[item]
}

struct artistSearch:Codable{
    let href:String
    let items:[Artist]
}

struct playlistSearch:Codable{
    let href:String
    let items:[itemOptions]
}

struct tracksSearch:Codable{
    let href:String
    let items:[AudioTrack]
}
