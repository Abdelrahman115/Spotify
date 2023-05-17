//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Abdelrahman on 04/05/2023.
//

import Foundation

struct RecommendationsResponse:Codable{
    let seeds:[Seed]
    let tracks:[AudioTrack]
}


struct Seed:Codable{
    let afterFilteringSize:Int
    let afterRelinkingSize:Int
    let href:String?
    let id:String
    let initialPoolSize:Int
    let type:String
}

struct AudioTrack:Codable{
    let album:album
    let available_markets:[String]
    let disc_number:Int
    let duration_ms:Int
    let explicit:Bool
    let external_ids:[String:String]
    let external_urls:[String:String]
    let href:String
    let id:String
    let name:String
    let popularity:Int
    let preview_url:String?
    let track_number:Int
    let type:String
    let uri:String
}


struct album:Codable{
    //let album_group:String
    let album_type:String?
    let artists:[Artist]
    let available_markets:[String]
    let external_urls:[String:String]
    let href:String
    let id:String
    let images:[image]?
    let name:String
    let release_date:String?
    let release_date_precision:String?
    let total_tracks:Int?
    let type:String?
    let uri:String?
    
}

