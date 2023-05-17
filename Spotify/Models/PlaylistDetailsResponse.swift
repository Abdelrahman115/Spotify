//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by Abdelrahman on 07/05/2023.
//

import Foundation

struct PlaylistDetailsResponse:Codable{
    let href:String
    let collaborative:Bool
    let description:String
    let external_urls:[String:String]
    let followers:follower
    let id:String
    let images:[image]
    let name:String
    let owner:ownerDetails
    //let public:Bool
    let tracks:playlistDetails
    //let items:[playlistOptions]
}

struct playlistDetails:Codable{
    let total:Int
    let items:[playlistItems]
}

struct playlistItems:Codable{
    let added_at:String?
    let followers:follower?
    let track:AudioTrack
}

struct playlistTracks:Codable{
    let album:playlistAlbum
    let artists:[Artist]
}

struct playlistAlbum:Codable{
    let album_type:String
    let total_tracks:Int
    let available_markets:[String]
    let href:String
    let id:String
    let images:[image]
    let name:String
    let genres:[String]?
    //let label:String
}



struct follower:Codable{
    let href:String?
    let total:Int?
}

struct ownerDetails:Codable{
    let external_urls:[String:String]
    //let followers:follower
    let href:String
    let id:String
    let type:String
    let uri:String
    let display_name:String
}


