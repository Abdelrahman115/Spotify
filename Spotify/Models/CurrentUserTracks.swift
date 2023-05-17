//
//  CurrentUserTracks.swift
//  Spotify
//
//  Created by Abdelrahman on 17/05/2023.
//

import Foundation


struct CureentUserTracksResponse:Codable{
    let href:String
    let items:[userTracks]
}

struct userTracks:Codable{
    let added_at:String
    let track:AudioTrack
}



